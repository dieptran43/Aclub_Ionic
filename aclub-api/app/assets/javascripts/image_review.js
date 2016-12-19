$(document).ready(function() {
  function readURL(input, index) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();

        reader.onload = function (e) {
            $('#image-preview-' + index + ' img').attr('src', e.target.result);
        }

        reader.readAsDataURL(input.files[0]);
    }
  }

  $('#coupon_image').change(function(){
      readURL(this, '');
  });

  $('#restaurant_profile_image').change(function(){
      readURL(this, '');
  });

  $('#menu_image').change(function(){
      readURL(this, '');
  }); 

  $('#restaurant_category_image').change(function(){
      readURL(this, '');
  });

  $('#advertising_event_home_page_background').change(function(){
      readURL(this, '1');
  });

  $('#advertising_event_win_page_background').change(function(){
      readURL(this, '2');
  });

  $(document).on('change', '.venue-images-attributes', function(){
      var index = $(this).attr('index-data');
      if($('#image-preview-' + index).length == 0) {
        $(this).parent().append("<div id='image-preview-" + index + "'><img></img></div>");
      }
      readURL(this, index);
  });

});