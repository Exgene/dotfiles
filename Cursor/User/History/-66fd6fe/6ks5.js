// how many users are active?
// what is the average age of all users
// list the top 5 common fruits among the users
// show all persons from usa
// show no of people having eyecolor green
// group data into no of males and females
// show all females having green eye color
// which country has the highest number of registered user
// show recently registered user
// show name, age of all users having tag ad

// Inserting sample user data
db.users.insertMany([
  {
    name: "Alice",
    age: 30,
    country: "USA",
    eyeColor: "green",
    fruits: ["apple", "banana"],
    tags: ["ad"],
  },
  {
    name: "Bob",
    age: 25,
    country: "USA",
    eyeColor: "blue",
    fruits: ["banana", "orange"],
    tags: [],
  },
  {
    name: "Charlie",
    age: 35,
    country: "Canada",
    eyeColor: "green",
    fruits: ["apple", "grape"],
    tags: ["ad"],
  },
  {
    name: "David",
    age: 28,
    country: "USA",
    eyeColor: "brown",
    fruits: ["banana", "kiwi"],
    tags: [],
  },
  {
    name: "Eve",
    age: 22,
    country: "USA",
    eyeColor: "green",
    fruits: ["apple", "banana"],
    tags: ["ad"],
  },
  {
    name: "Frank",
    age: 40,
    country: "UK",
    eyeColor: "blue",
    fruits: ["orange", "grape"],
    tags: [],
  },
  {
    name: "Grace",
    age: 29,
    country: "USA",
    eyeColor: "green",
    fruits: ["banana", "apple"],
    tags: ["ad"],
  },
  {
    name: "Hank",
    age: 33,
    country: "USA",
    eyeColor: "brown",
    fruits: ["kiwi", "banana"],
    tags: [],
  },
  {
    name: "Ivy",
    age: 27,
    country: "USA",
    eyeColor: "green",
    fruits: ["apple", "banana"],
    tags: [],
  },
  {
    name: "Jack",
    age: 31,
    country: "Canada",
    eyeColor: "blue",
    fruits: ["grape", "orange"],
    tags: [],
  },
]);
