---
title: x-whatsapp
description: implementation of external brain for whatsapp
sidebar:
  order: 1
---

Python library for interacting with Whatsapp using Playwright.

Since the library code is getting very messy, I will write the docs for it simultaneously while building the library.

### Locators

- get_focused_element_locator()
  - returns None | locator for current focused element
- get_search_box_locator()
  - returns playwright locator for search box
-

### Helper functions

- select_text_and_delete()
  - selects all text in the currently selected item and deletes it
- search_pane_scroll_down()
- chat_pane_scroll_up()

### Core functions

- logout
  - logs out from your current Whatsapp session
- find_user(str)
  - TODO: don't open the chat panel corresponding to the user
  - returns False if username starting with `str` doesn't exist
  - returns the best matching username that starts with `str` if it exists
  - for exact match you need to perform an additional check of whether str == returned value

Finding via phone number

- check_valid_number(str)
- create_new_chat(str)
  - TODO: check whether the phone number provided is valid or invalid
    - currently if the phone number is invalid, the program breaks
    - return True if phone number provided is valid, False otherwise
    - be able to handle various types of phone string (via regex)
    - use country code `+91` if not present
    - maybe change the name to avoid confusion (if the user needs to find the already saved contact whose number is known, they should use the find_user_function)
  - currently the str should be in format "+911234567890"

### Search & Chat pane functions

New message listener

- Checking the first chat (every 10 seconds)
- Retrieval notifications
  - Use of notifications to obtain new messages

Search Pane

- get_first_chat(ignore_pinned: bool = True)
  - TODO: this function currently opens the chat
    - retrieve the first chat without opening the chats
  - selects the most recent chat (by default ignoring all the pinned chats)

Chat Pane

- get_newest_message
- get_oldest_message
- retrieve_all_messages

### Chat database schema (for future)

| Chat ID                | Message ID | Sender | Time Sent | Message | Additional details |
| ---------------------- | ---------- | ------ | --------- | ------- | ------------------ |
| unique id for the chat |            |        |           |         |                    |

Primary Key → Chat ID + Message ID

### Additional details

| Forwarded     | Replying to message | Attachment                  |
| ------------- | ------------------- | --------------------------- |
| True \| False | False \| Message ID | False \| Attachment Details |

Attachment Details

- type → Image, PDF, other
- size → in bytes or megabytes
- link (to the actual attachment)
  - the attachment could be saved in another database or the same one
-

## Sending messages

- Sending a regular message
  - existing contact
  - to a new contact (via phone number)
- Replying to a message
- Sending images, pdfs, videos, attachments
- Forwarding a message
- Sending stickers

---
