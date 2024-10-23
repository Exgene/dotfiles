// Create collections
db.createCollection("product");
db.createCollection("inventory");

// Insert and update data in product collection
db.product.bulkWrite([
  {
    insertOne: {
      document: {
        _id: 1,
        name: "marker",
        price: 15,
        stock: 10,
      },
    },
  },
  {
    insertOne: {
      document: {
        _id: 2,
        name: "scale",
        price: 5,
        stock: 20,
      },
    },
  },
  {
    updateOne: {
      filter: { name: "marker" },
      update: { $set: { price: 20 } },
    },
  },
]);

// Insert and update data in inventory collection
db.inventory.bulkWrite([
  {
    insertOne: {
      document: {
        p_id: 1,
        stock: 10,
      },
    },
  },
  {
    insertOne: {
      document: {
        p_id: 2,
        stock: 20,
      },
    },
  },
  {
    insertOne: {
      document: {
        p_id: 3,
        stock: 5,
      },
    },
  },
  {
    updateOne: {
      filter: { p_id: 1 },
      update: { $set: { stock: 15 } },
    },
  },
]);

// Verify data
print("Products:");
printjson(db.product.find().toArray());
print("\nInventory:");
printjson(db.inventory.find().toArray());

// Left outer join
print("\nLeft Outer Join (All products with their inventory, if exists):");
printjson(
  db.product
    .aggregate([
      {
        $lookup: {
          from: "inventory",
          localField: "_id",
          foreignField: "p_id",
          as: "inventory_info",
        },
      },
    ])
    .toArray()
);

// Right outer join
print("\nRight Outer Join (All inventory with their products, if exists):");
printjson(
  db.inventory
    .aggregate([
      {
        $lookup: {
          from: "product",
          localField: "p_id",
          foreignField: "_id",
          as: "product_info",
        },
      },
    ])
    .toArray()
);

// Inner join
print("\nInner Join (Only products with matching inventory):");
printjson(
  db.product
    .aggregate([
      {
        $lookup: {
          from: "inventory",
          localField: "_id",
          foreignField: "p_id",
          as: "inventory_info",
        },
      },
      {
        $match: {
          inventory_info: { $ne: [] },
        },
      },
    ])
    .toArray()
);

// Full join
print("\nFull Join (All products and all inventory):");
printjson(
  db.product
    .aggregate([
      {
        $lookup: {
          from: "inventory",
          localField: "_id",
          foreignField: "p_id",
          as: "inventory_info",
        },
      },
      {
        $unionWith: {
          coll: "inventory",
          pipeline: [
            {
              $lookup: {
                from: "product",
                localField: "p_id",
                foreignField: "_id",
                as: "product_info",
              },
            },
            {
              $match: {
                product_info: { $eq: [] },
              },
            },
          ],
        },
      },
    ])
    .toArray()
);
