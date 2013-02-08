(function(a){if(window.filepicker){return}var b=a.createElement("script");b.type="text/javascript";b.async=!0;b.src=("https:"===a.location.protocol?"https:":"http:")+"//api.filepicker.io/v1/filepicker.js";var c=a.getElementsByTagName("script")[0];c.parentNode.insertBefore(b,c);var d={};d._queue=[];var e="pick,pickMultiple,pickAndStore,read,write,writeUrl,export,convert,store,storeUrl,remove,stat,setKey,constructWidget,makeDropPane".split(",");var f=function(a,b){return function(){b.push([a,arguments])}};for(var g=0;g<e.length;g++){d[e[g]]=f(e[g],d._queue)}window.filepicker=d})(document);

HasFilepickerImage = {};

HasFilepickerImage.previewPickedFile = function(event) {
  var container, elem;
  elem = $(event.target);
  container = null;
  if (elem.siblings('.filepicker-image').size() > 0) {
    container = elem.siblings('.image:first');
  } else {
    container = $("<div class='filepicker-image'></div>");
    elem.after(container);
  }
  return container.html("<img src='" + event.fpfile.url + '/convert?w=260&h=180' + '\'/>');
};

$(document).on('nested:fieldAdded', function(event) {
  var $element, field;
  field = event.field;
  $element = field.find("[type='filepicker']");
  if ($element.size() > 0) {
    return filepicker.constructWidget($element);
  }
});
