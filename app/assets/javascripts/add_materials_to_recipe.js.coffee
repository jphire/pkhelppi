window.add_material = (e) ->
  choice = $('#post_material_id').get(0)
  val = choice.value
  elem = document.createElement('input')
  list_elem = document.createElement('li')
  list_elem.innerHTML = choice.children[val-1].innerHTML + "</br>"
  elem.type = "hidden"
  elem.name = "new_materials[" + val + "]"
  elem.value = val
  $('#recipe_materials').append elem
  $('#recipe_materials').append list_elem
  console.log val
