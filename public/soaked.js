var since;

$(document).ready(function(){
    since = new Date();
    var refreshId = setInterval(update, 10*1000);
});

function update() {
  $.getJSON('/events/json?since='+Math.floor(since.getTime()/1000), function(data) {
    $(data).each(function() {
      $("<div>", {
        'class': 'event',
        html:    this.message + ' <span class="timestamp">' + this.timestamp + '</span>'
      }).hide().prependTo('#events').fadeIn('slow');
    });
    since=new Date();
  });
} 
