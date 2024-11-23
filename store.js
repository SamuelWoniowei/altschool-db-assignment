// (a) creation of all the entities
db.createCollection("users");
db.createCollection("categories");
db.createCollection("items");
db.createCollection("orders");

// (b) Show commands for inserting records into the entities
// create an admin and user entity
db.users.insertMany([
  {
    fullname: "Ade James",
    username: "adjames",
    address: "No.4 db lane, Sql road",
    email: "adjames@email.com",
    password: "jamespasswordhere",
    role: "admin",
    created_at: Date(),
  },
  {
    fullname: "Miriam Nosa",
    username: "mnosa",
    address: "No.94 link road ",
    email: "mnosa@mail.com",
    password: "nosapass",
    role: "user",
    created_at: Date(),
  },
]);

// Insert into categories
db.categories.insertMany([
  { name: "clothing" },
  { name: "electronics" },
  { name: "books" },
  { name: "cars" },
]);

// Insert into items
db.items.insertMany([
  {
    name: "Nigerian Jersey",
    description: "The newest Nigerian jersey design",
    price: 25000,
    size: "l",
    category_id: ObjectId("6741cc5be8144f65ac23bc12"),
    created_at: Date(),
  },
  {
    name: "Mechanical Keyboard'",
    description: "Porodo mech keyboard",
    price: 40000,
    size: "10x20cm",
    category_id: ObjectId("6741cc5be8144f65ac23bc13"),
    created_at: Date(),
  },
]);

// Insert into Orders
db.orders.insertOne({
  user_id: ObjectId("6741c7e6e8144f65ac23bc11"),
  item_id: ObjectId("6741ccc3e8144f65ac23bc16"),
  status: "pending",
  created_at: Date(),
});

// (c) Show commands for getting records from two or more entities
// get all non-admin users
db.users.find({ role: "user" });

// get al items
db.items.find({});

// (d) Show commands for updating records from two or more entities
// updated the status of an order
db.orders.updateOne(
  {
    user_id: ObjectId("6741c7e6e8144f65ac23bc11"),
    item_id: ObjectId("6741ccc3e8144f65ac23bc16"),
  },
  { $set: { status: "completed" } }
);

// update the email of a user
db.users.updateOne(
  { _id: ObjectId("6741c7e6e8144f65ac23bc11"), role: "user" },
  { $set: { email: "newmail.mail.com" } }
);

// (e) show commands for deleting records from two or more entities
// delete a category
db.categories.deleteOne({ _id: ObjectId("6741cc5be8144f65ac23bc15") });

// delete an item
db.items.deleteOne({ _id: ObjectId("6741ccc3e8144f65ac23bc17") });

// (f) show commands for query records from multiple entities using joins
// get all items and their respective categories
db.items.aggregate([
  {
    $lookup: {
      from: "categories",
      localField: "category_id",
      foreignField: "_id",
      as: "category",
    },
  },
  {
    $unwind: "$category",
  },
  {
    $project: {
      _id: "$_id",
      name: "$name",
      description: "$decription",
      price: "$price",
      size: "$size",
      category: "$category.name",
      created_at: "$created_at",
    },
  },
]);

//get full details about al orders
db.orders.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "user_id",
      foreignField: "_id",
      as: "user",
    },
  },
  {
    $lookup: {
      from: "items",
      localField: "item_id",
      foreignField: "_id",
      as: "item",
    },
  },
  {
    $unwind: "$item",
  },
  {
    $lookup: {
      from: "categories",
      localField: "item.category_id",
      foreignField: "_id",
      as: "category",
    },
  },
  {
    $unwind: "$category",
  },
  {
    $project: {
      order_id: "$_id",
      user_name: { $arrayElemAt: ["$user.fullname", 0] },
      user_email: { $arrayElemAt: ["$user.email", 0] },
      item_name: "$item.name",
      item_price: "$item.price",
      category_name: "$category.name",
      status: 1,
      created_at: 1,
    },
  },
]);
