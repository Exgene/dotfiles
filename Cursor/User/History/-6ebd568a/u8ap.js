import fs from "fs";
import http from "http";
import url from "url";
const PORT = 3000;
const LOCALHOST = "127.0.0.1";

fs.readFile("books.json", "utf8", (err, data) => {
  if (err != null) {
    console.log(err);
    return;
  }

  const books = JSON.parse(data);

  const server = http.createServer((req, res) => {
    const { pathname, query } = url.parse(req.url, true);
    switch (pathname) {
      case "/":
        res.writeHead(200, { "Content-Type": "application/json" });
        res.end(JSON.stringify(books));
        break;

      case "/filterByTitle":
        const title = query.title.toLowerCase();
        const book = books.find((book) => book.title.toLowerCase() === title);
        if (book) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(book));
        } else {
          res.writeHead(404, { "Content-Type": "text/plain" });
          res.end("Book not found");
        }
        break;

      case "/filterByLanguage":
        const language = query.language.toLowerCase();
        const booksByLanguage = books.filter(
          (book) => book.language.toLowerCase() === language
        );
        if (booksByLanguage.length > 0) {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(booksByLanguage));
        } else {
          res.writeHead(404, { "Content-Type": "text/plain" });
          res.end("Books not found");
        }
        break;

      default:
        res.writeHead(404, { "Content-Type": "text/plain" });
        res.end("Not found page path named " + pathname);
    }
  });

  server.listen(PORT, LOCALHOST, () => {
    console.log(`Server is running on http://${LOCALHOST}:${PORT}`);
  });
});
