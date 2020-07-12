alias LiveViewDemo.Kanban

{ok, board} = Kanban.create_board(%{name: "board"})

{:ok, to_do_stage} = Kanban.create_stage(%{name: "Mario", board_id: board.id})
Kanban.create_stage(%{name: "Luigi", board_id: board.id})
Kanban.create_stage(%{name: "Yoshi", board_id: board.id})

Kanban.create_card(%{name: "Cheese Burger", pricePerUnit: 12.75, price: 25.50, quantity: 2, stage_id: to_do_stage.id})
Kanban.create_card(%{name: "Caesar Salad", pricePerUnit: 8.00, price: 24.00, quantity: 3, stage_id: to_do_stage.id})
Kanban.create_card(%{name: "Roasted Beet", pricePerUnit: 9.00, price: 9.00, quantity: 1, stage_id: to_do_stage.id})
Kanban.create_card(%{name: "Housemade Bread", pricePerUnit: 7.00, price: 7.00, quantity: 1, stage_id: to_do_stage.id})

