head.ready(function() {
  
  // Colorbox lightbox for images
  //
  $('article').each(function() { $(this).find('p.image a, a.cb-image').colorbox(); })
});