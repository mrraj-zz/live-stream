$(document).ready(function(){
  var $onlineUsersEvent = new EventSource('/online_users/users');
  var $response, $onlineUsers;

  $onlineUsersEvent.addEventListener('online-users', function(e){
    $response    = JSON.parse(e.data);
    $onlineUsers = $("<ul class='nav nav-list'></ul>");

    $response.online_users.forEach(function(user){
      $("<li><a href='#'>"+user+"</a></li>").appendTo($onlineUsers);
    });
    $('#online-users').html($onlineUsers);
  });
});
