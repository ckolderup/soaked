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

function loadMore() {
  var timestamp = new Date();
  timestamp.setISO8601(jQuery.trim($(".event .timestamp").last().text()));
  $.getJSON('/events/json?before='+Math.floor(timestamp.getTime()/1000), function(data) {
    $.each($(data).get().reverse(), function() {
      $("<div>", {
        'class': 'event',
        html: this.message + ' <span class="timestamp">' + this.timestamp + '</span>'
      }).hide().appendTo('#events').fadeIn('slow');
    }); 
    if (data.length == 0) {
     $("#gimme").removeAttr("onclick");
     $("#gimme").addClass("disabled"); 
    }
  });
}

Date.prototype.setISO8601 = function(dString){
  var regexp = /(\d\d\d\d)(-)?(\d\d)(-)?(\d\d)(T)?(\d\d)(:)?(\d\d)(:)?(\d\d)(\.\d+)?(Z|([+-])(\d\d)(:)?(\d\d))/;
  if (dString.toString().match(new RegExp(regexp))) {
    var d = dString.match(new RegExp(regexp));
    var offset = 0;
    this.setUTCDate(1);
    this.setUTCFullYear(parseInt(d[1],10));
    this.setUTCMonth(parseInt(d[3],10) - 1);
    this.setUTCDate(parseInt(d[5],10));
    this.setUTCHours(parseInt(d[7],10));
    this.setUTCMinutes(parseInt(d[9],10));
    this.setUTCSeconds(parseInt(d[11],10));
    if (d[12]) {
      this.setUTCMilliseconds(parseFloat(d[12]) * 1000);
    }
    else {
      this.setUTCMilliseconds(0);
    }
    if (d[13] != 'Z') {
      offset = (d[15] * 60) + parseInt(d[17],10);
      offset *= ((d[14] == '-') ? -1 : 1);
      this.setTime(this.getTime() - offset * 60 * 1000);
    }
  }
  else {
    this.setTime(Date.parse(dString));
  }
  return this;
};
