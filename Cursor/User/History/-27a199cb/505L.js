// Select the database to use.
use("mycompany");

// insert person details

// db.persons.insertMany([
//   {
//     name: "John Doe",
//     age: 30,
//     bio: "Software Engineer",
//     hobbies: ["reading", "hiking"],
//     experience: [
//       { company: "ABC Corp", duration: "2 years" },
//       { company: "XYZ Inc", duration: "1 year" },
//     ],
//     identity: {
//       hasPassport: true,
//       hasAadhar: true,
//     },
//   },
//   {
//     name: "Jane Smith",
//     age: 25,
//     bio: "Data Analyst",
//     hobbies: ["painting", "cooking"],
//     experience: [
//       { company: "PQR Ltd", duration: "3 years" },
//       { company: "MNO Pvt", duration: "2 years" },
//     ],
//     identity: {
//       hasPassport: false,
//       hasAadhar: true,
//     },
//   },
// ]);

db.persons.find().pretty();

// db.createCollection("product");
// db.createCollection("inventory");

db.product.bulkWrite(
  [
    {insertMany: [
      {
        name: "marker",
        price: 15,
        stock: 10,
      },
      {
        name: "scale",
        price: 5,
        stock: 20,
      },
    ]},
    {updateOne: {
      filter: {name: "marker"},
      update: {$set: {price: 20}}
    }}
  ]
)