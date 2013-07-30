$(document).ready(function(){
  $("textarea#message").keypress(function(e){
    if(e.which == 13) {
      $(this).closest("form").submit();
      return false;
    }
  });
});
