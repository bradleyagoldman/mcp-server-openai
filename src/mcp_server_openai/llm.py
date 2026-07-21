import base64
import logging
import os
import time
from openai import AsyncOpenAI

logger = logging.getLogger(__name__)

class LLMConnector:
    def __init__(self, openai_api_key: str):
        self.client = AsyncOpenAI(api_key=openai_api_key)

    async def ask_openai(self, query: str, model: str = "gpt-4o", temperature: float = 0.7, max_tokens: int = 500) -> str:
        try:
            response = await self.client.chat.completions.create(
                messages=[
                    {"role": "system", "content": "You are a helpful assistant."},
                    {"role": "user", "content": query}
                ],
                model=model,
                temperature=temperature,
                max_tokens=max_tokens
            )
            return response.choices[0].message.content
        except Exception as e:
            logger.error(f"Failed to query OpenAI: {str(e)}")
            raise

    async def generate_image(self, prompt: str, size: str = "1024x1536", output_dir: str | None = None) -> str:
        try:
            response = await self.client.images.generate(
                model="gpt-image-1",
                prompt=prompt,
                size=size,
                n=1,
            )
            b64_data = response.data[0].b64_json
            image_bytes = base64.b64decode(b64_data)

            target_dir = output_dir or os.path.expanduser("~/Desktop/Claude NBS/_Temp")
            os.makedirs(target_dir, exist_ok=True)
            filename = f"gpt-image-{int(time.time())}.png"
            output_path = os.path.join(target_dir, filename)
            with open(output_path, "wb") as f:
                f.write(image_bytes)

            return output_path
        except Exception as e:
            logger.error(f"Failed to generate image: {str(e)}")
            raise