from __init__ import WhatsappClient
import asyncio


async def periodic_chat_update(client: WhatsappClient, interval: int = 20):
    """
    Periodically fetches and updates chats for specified users.

    :param client: WhatsappClient instance
    :param interval: Time interval in seconds (default: 20)
    """
    while True:
        await client.update_database("Karthik")
        await asyncio.sleep(interval)


client = WhatsappClient()
asyncio.run(periodic_chat_update(client))
