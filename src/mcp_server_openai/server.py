import asyncio
import logging
import sys
from typing import Optional

import click
import mcp
import mcp.types as types
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions

from .llm import LLMConnector

logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)

def serve(openai_api_key: str) -> Server:
    server = Server("openai-server")
    connector = LLMConnector(openai_api_key)

    @server.list_tools()
    async def handle_list_tools() -> list[types.Tool]:
        return [
            types.Tool(
                name="ask-openai",
                description="Ask my assistant models a direct question",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "query": {"type": "string", "description": "Ask assistant"},
                        "model": {"type": "string", "default": "gpt-4o", "enum": ["gpt-4o", "gpt-4o-mini", "gpt-4", "gpt-3.5-turbo"]},
                        "temperature": {"type": "number", "default": 0.7, "minimum": 0, "maximum": 2},
                        "max_tokens": {"type": "integer", "default": 500, "minimum": 1, "maximum": 4000}
                    },
                    "required": ["query"]
                }
            ),
            types.Tool(
                name="generate-image",
                description="Generate an image from a text prompt using OpenAI's gpt-image-1 model. Returns the local file path of the saved PNG.",
                inputSchema={
                    "type": "object",
                    "properties": {
                        "prompt": {"type": "string", "description": "Description of the image to generate"},
                        "size": {"type": "string", "default": "1024x1536", "enum": ["1024x1024", "1024x1536", "1536x1024"]},
                        "output_dir": {"type": "string", "description": "Absolute directory path to save the image in. Defaults to ~/Desktop/Claude NBS/_Temp"}
                    },
                    "required": ["prompt"]
                }
            )
        ]

    @server.call_tool()
    async def handle_tool_call(name: str, arguments: dict | None) -> list[types.TextContent]:
        try:
            if not arguments:
                raise ValueError("No arguments provided")

            if name == "ask-openai":
                response = await connector.ask_openai(
                    query=arguments["query"],
                    model=arguments.get("model", "gpt-4o"),
                    temperature=arguments.get("temperature", 0.7),
                    max_tokens=arguments.get("max_tokens", 500)
                )
                return [types.TextContent(type="text", text=f"OpenAI Response:\n{response}")]

            if name == "generate-image":
                output_path = await connector.generate_image(
                    prompt=arguments["prompt"],
                    size=arguments.get("size", "1024x1536"),
                    output_dir=arguments.get("output_dir"),
                )
                return [types.TextContent(type="text", text=f"Image saved to: {output_path}")]

            raise ValueError(f"Unknown tool: {name}")
        except Exception as e:
            logger.error(f"Tool call failed: {str(e)}")
            return [types.TextContent(type="text", text=f"Error: {str(e)}")]

    return server

@click.command()
@click.option("--openai-api-key", envvar="OPENAI_API_KEY", required=True)
def main(openai_api_key: str):
    try:
        async def _run():
            async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
                server = serve(openai_api_key)
                await server.run(
                    read_stream, write_stream,
                    InitializationOptions(
                        server_name="openai-server",
                        server_version="0.1.0",
                        capabilities=server.get_capabilities(
                            notification_options=NotificationOptions(),
                            experimental_capabilities={}
                        )
                    )
                )
        asyncio.run(_run())
    except KeyboardInterrupt:
        logger.info("Server stopped by user")
    except Exception as e:
        logger.exception("Server failed")
        sys.exit(1)

if __name__ == "__main__":
    main()