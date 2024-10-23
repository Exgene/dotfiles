---
title: Schema
description: Schema for the x-whatsapp implementation
sidebar:
  order: 2
---

## Chat Database Schema (for Future)

| Chat ID                | Message ID | Sender | Time Sent | Message | Additional Details |
| ---------------------- | ---------- | ------ | --------- | ------- | ------------------ |
| Unique ID for the chat |            |        |           |         |                    |

Primary Key → Chat ID + Message ID

### Additional Details

| Forwarded     | Replying to Message | Attachment                  |
| ------------- | ------------------- | --------------------------- |
| True \| False | False \| Message ID | False \| Attachment Details |
