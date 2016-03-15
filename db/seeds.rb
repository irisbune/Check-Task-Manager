Task.destroy_all
Project.destroy_all

project1 = Project.create!({
  name: "Kitchen renovation",
  description: "Tote bag keytar sartorial, actually narwhal yuccie listicle. Pitchfork literally trust fund heirloom franzen, leggings schlitz deep v vice kale chips williamsburg meh hashtag ugh. Swag kinfolk echo park bespoke, small batch tilde tousled chambray meditation green juice affogato irony helvetica mustache."
  })
project2 = Project.create!({
  name: "Applying for my first web dev job",
  description: "The walk of shame"
  })
task1 = Task.create!({
  task_description: "Write application letter",
  duedate: Date.today,
  project_id: project2.id
  })
