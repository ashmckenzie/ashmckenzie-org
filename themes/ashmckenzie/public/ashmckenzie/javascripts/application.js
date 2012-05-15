$(document).ready(function() {
  $('ul.technologies li a, p.intro a, footer a').each(function() { $(this).attr('target', '_blank') });
});