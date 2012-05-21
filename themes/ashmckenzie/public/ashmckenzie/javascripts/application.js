$(document).ready(function() {
  
  // Add a description <p> tag under each image and add title to <a> tag so
  // Colorbox can utilise it
  //
  // $('p.image').each(function() { 
  //   var a = $(this).find('a');
  //   var img = $(this).find('img');
  //   $(a).attr('title', $(img).attr('title'));
  //   $('<p class="title">' + $(img).attr('title') + '</p>').insertAfter($(img));
  // })

  // Colorbox lightbox for images
  //
  $('article').each(function() { $(this).find('p.image a').colorbox(); })
});