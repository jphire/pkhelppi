window.remove_list_element = (id) ->
  console.log id
  choice = $("##{id}").get(0);
  console.log choice
  choice.parentElement.removeChild(choice);
  
