---
title: How does it work?
description: How does x-cortex work?
tableOfContents: false
sidebar:
  order: 3
---

we can divide message retrieval and message sending into two browsers... this will probably make things easier in the short term (later we can consolidate)

## SQLite database

### Scheduled Messages

- chatID, provider, Time to send, message

### Mapper

(helper to find the correct chatID)

- maps a number to a chatID
- map username + provider to chatID
- also map group name + provider to chatID
  - ps. every group has a unique chatID unlike users

### Chats

Also probably add a provider column (eg. whatsapp, telegram, viber etc.)

| Chat ID | Message ID | Provider                | Sender | Time Sent | Message |
| ------- | ---------- | ----------------------- | ------ | --------- | ------- |
|         |            | Whatsapp / Telegram etc |        |           |         |

| Forwarded     | Replying to message | Attachment                  |
| ------------- | ------------------- | --------------------------- |
| True \| False | False \| Message ID | False \| Attachment Details |

Primary Key → Chat ID + Message ID

Attachment Details

- type → Image, PDF, other
- size → in bytes or megabytes
- link (to the actual attachment)
  - the attachment could be saved in another database or the same one
- etc.

### x-cortex processing queue

---

## Working of x-cortex for messages

Whenever a new message is added to the database, the chatID is added to x-cortex processing queue (if the sender isn't You and the chatID isn't already present). If the x-cortex is free it will retrieve the previous x messages from the corresponding chatID and creates scheduled messages if necessary.

---
