alias LiveViewDemo.Kanban

{ok, board} = Kanban.create_board(%{name: "Spring Cleaning"})

{:ok, to_do_stage} = Kanban.create_stage(%{name: "To Do", board_id: board.id})
Kanban.create_stage(%{name: "Doing", board_id: board.id})
Kanban.create_stage(%{name: "Done", board_id: board.id})

Kanban.create_card(%{name: "Tidy bedroom", stage_id: to_do_stage.id})
Kanban.create_card(%{name: "Buy some storage boxes", stage_id: to_do_stage.id})
Kanban.create_card(%{name: "Fix shower", stage_id: to_do_stage.id})
