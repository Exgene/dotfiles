import sqlite3


def create_database():
    """Creates a SQLite database named main.sqlite."""
    db_name = "data/main.sqlite"
    connection = sqlite3.connect(db_name)
    cursor = connection.cursor()

    # Create a sample table
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS chats (
            chatId INTEGER NOT NULL,
            messageId INTEGER NOT NULL,
            provider TEXT NOT NULL,
            sender TEXT NOT NULL,
            time_sent TEXT NOT NULL,
            message TEXT NOT NULL,
            PRIMARY KEY(chatId, messageId)
        )
    """
    )

    connection.commit()
    connection.close()


def insert_message(
    chatId: int,
    messageId: int,
    provider: str,
    sender: str,
    time_sent: str,
    message: str,
):
    """Inserts a message into the chats table."""
    connection = sqlite3.connect("main.sqlite")
    cursor = connection.cursor()

    cursor.execute(
        "INSERT INTO chats (chatId, messageId, provider, sender, time_sent, message) VALUES (?, ?, ?, ?, ?, ?)",
        (
            chatId,
            messageId,
            provider,
            sender,
            time_sent,
            message,
        ),  # Ensure parameters are passed correctly
    )

    connection.commit()
    connection.close()


create_database()
insert_message(1, 1, "test", "test", "2023-10-01 12:00:00", "test")


def get_messages(chatId: int):
    """Gets all messages from the chats table."""
    connection = sqlite3.connect("main.sqlite")
    cursor = connection.cursor()

    cursor.execute("SELECT * FROM chats WHERE chatId = ?", (chatId,))
    messages = cursor.fetchall()
    return messages


print(get_messages(1))
