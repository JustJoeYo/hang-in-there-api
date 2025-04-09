Poster.destroy_all

Poster.create(
  name: "REGRET",
  description: "Hard work rarely pays off.",
  price: 90.00,
  year: 2025,
  vintage: false,
  img_url: "https://miro.medium.com/v2/resize:fit:1200/1*uNCVd_VqFOcdxhsL71cT5Q.jpeg"
)

Poster.create(
  name: "FART",
  description: "Hard work rarely pays off.",
  price: 99.00,
  year: 2025,
  vintage: true,
  img_url: "https://miro.medium.com/v2/resize:fit:1200/1*uNCVd_VqFOcdxhsL71cT5Q.jpeg"
)

Poster.create(
  name: "Art",
  description: "Frickity Heckity.",
  price: 60.00,
  year: 2024,
  vintage: false,
  img_url: "https://miro.medium.com/v2/resize:fit:1200/1*uNCVd_VqFOcdxhsL71cT5Q.jpeg"
)

Poster.create(
  name: "Zart",
  description: "Zarting is a form of art.",
  price: 20.00,
  year: 2020,
  vintage: true,
  img_url: "https://miro.medium.com/v2/resize:fit:1200/1*uNCVd_VqFOcdxhsL71cT5Q.jpeg"
)

puts "Created #{Poster.count} posters"