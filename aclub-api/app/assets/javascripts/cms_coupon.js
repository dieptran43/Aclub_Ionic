$(document).ready(function() {
  $('#coupon-start-date-calendar').on('click', function(){
    $('#coupon_start_date').datepicker('show');
  })

  $('#coupon-end-date-calendar').on('click', function(){
    $('#coupon_end_date').datepicker('show');
  })

  $('#infinity-quantity').on('click', function() {
    var element = $(this);
    if(element.hasClass('fa-square-o')) {
      element.removeClass('fa-square-o');
      element.addClass('fa-square');
      $('#coupon_quantity').attr('disabled', 'disabled');
      $('#coupon_quantity').val(9999999);
    } else {
      element.removeClass('fa-square');
      element.addClass('fa-square-o');
      $('#coupon_quantity').attr('disabled', false);
    }
  });

  $(document).on('click', '#restaurant-name-search', function() {
    $.ajax({
      method: 'GET',
      url: '/cms/restaurants',
      dataType: 'json',
      data: { query: $('#restaurant-name-search').val() }
    }).done(function(data) {
      var output = [];
      $.each(data, function(index) { output.push('<option value="'+ data[index][1] +'">'+ data[index][0] +'</option>'); })
      $('#coupon_restaurant_id').html(output.join(''));
      $('#restaurant_id').html(output.join(''));
    })
  })

  $(document).on('click', '.submit-code-for-redeem', function() {
    var parent = $(this).parent();
    var code = $(parent).find('.coupon-code').val()
    var coupon_id = $(parent).find('.coupon-id').val()
    $.ajax({
      method: 'POST',
      url: '/owner/coupons/redeem_code',
      dataType: 'json',
      data: { coupon_id: coupon_id, code: code }
    }).done(function(data) {
      $('.result-text').html(data.message)
    })
  })
});