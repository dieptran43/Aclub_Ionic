$(document).ready(function() {

  var token = $('#facebook-token').attr('data-token');
  var email = $('#email').attr('data-email');
  var advertising_event_id = $('#advertising-event-id').attr('data-advertising-event-id');

  $('#regiter-phone').on('click', function() {
    var confirmation_box = confirm("Số điện thoại đã đăng ký: " + $('#phone').val() + ". Bạn sẽ không thể thay đổi, xin hãy chắc chắn." );
    if (confirmation_box == true) {
      $.ajax({
        method: 'POST',
        url: '/advertising_events/register_phone',
        data: { phone: $('#phone').val(), name: $('#name').val(), email: email, token: token }
      }).done(function() {
        window.location = '/advertising_events/phone_registration_page?email=' + email + '&token='  + token + '&advertising_event_id=' + advertising_event_id;
      }).error(function(data) {
        var errors = JSON.parse(data.responseText).messages;
        $('.alert').removeClass('hidden');
        $('.alert').html("<p>" + errors + "</p>");
      });
    }
  });

  $('#verify-phone').on('click', function() {
    $.ajax({
      method: 'POST',
      url: '/advertising_events/verify_phone',
      data: { 
              verification_token: $('#verification-code').val(), 
              email: email, 
              token: token,
              advertising_event_id: advertising_event_id
            }
    }).done(function(data) {
      if(data.win) {
        window.location = '/advertising_events/reward?email=' + email + '&token='  + token + '&advertising_event_id=' + advertising_event_id;
      } else {
        window.location = '/advertising_events/thank_you?email=' + email;
      }
    }).error(function(data) {
      var errors = JSON.parse(data.responseText).messages;
      $('.alert').html("<p>" + errors + "</p>");
      $('.alert').removeClass('hidden');
    });
  });

  $('#resend-verification-token').on('click', function() {
    $.ajax({
      method: 'POST',
      url: '/advertising_events/resend_phone_token',
      data: { email: email, token: token }
    }).done(function() {}).error(function(data) {});
  })
});
