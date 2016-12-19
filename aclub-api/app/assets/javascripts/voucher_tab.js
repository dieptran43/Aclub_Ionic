if(typeof(rootUrl) !== 'undefined') {
    var protocol = 'https://';
    var URL_MSG = protocol + rootUrl + '/facebook/voucher/registration';
    var URL_ResendSMS = protocol + rootUrl + '/facebook/voucher/sendsms';
    $(document).ready(function () {
        $('#play_agame_btn').click(function () {
            $('#playInfo').slideToggle();
            $('#play_agame_btn').hide();
            $('#revice_voucher_btn').show();
        });

        $('#btn_close_md').click(function () {
            $('#modal_have_voucher').modal('hide');
        });

        $('#other_voucher_btn').click(function () {
            $('#modal_have_voucher').modal('hide');
        });

        $('#btn_close_nomd').click(function () {
            $('#modal_no_voucher').modal('hide');
        });

        $('#sms_code_id').keyup(function(){
            var step = $('#stepgetVou').val();
            if(step == 1){
                var value = $(this).val();
                if($.trim(value)==''){
                    $('#revice_voucher_btn').prop("disabled", true);
                }else{
                    $('#revice_voucher_btn').prop("disabled", false);
                }
            }
        });

        $('#revice_voucher_btn').click(function () {

            var step = $('#stepgetVou').val();
            var fullName = $('#playname').val();
            var phone = $('#playphone').val();
            if (step == "0") {
                if (fullName == null || fullName == "") {
                    $('#playname').focus();
                    return false;
                }

                if (phone == null || phone == "") {
                    $('#playphone').focus();
                    return false;
                }

                checkPhoneNumber(phone);
            } else if (step == "1") {
                var token = $('#sms_code_id').val();

                if (token == null || token == "") {
                    $('#sms_code_id').focus();
                    return false;
                } else {
                    verifyCodeAndGetVoucher(phone, token);
                }
            }
        });

        $('#modal_have_voucher').on('hidden.bs.modal', function (e) {
            $('#playphone').val("");
            $('#playname').val("");
            $('#sms_code_id').val("");
            $('#playInfo').hide();
            $('#play_agame_btn').show();
            $('#other_voucher_btn').hide();
            $('#verifycation_code').hide();
            $('#voucher_result').hide();
            $('#revice_voucher_btn').hide();
            $('#revice_voucher_btn').attr("disabled", false);
            $('#stepgetVou').val(0);
        });
    });

    function verifyCodeAndGetVoucher(phone, token) {
        var data = {
            "user": {
                "phone": phone,
                "coupon_id": $("#couponId").val(),
                "verification_code" : $("#sms_code_id").val()
            }
        };
        $.ajax({
            type: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            async:false,
            url: URL_MSG,
            dataType: 'json',
            data: JSON.stringify(data),
            success: function (msg) {
                showResult(msg);
                $('#stepgetVou').val(0);
            }, error: function (jqXHR, msg, error) {
                alert(jqXHR.responseJSON.errors);
                return msg;
            }
        });
    }

    function showResult(result) {
        if(result.status == 1){
            if(result.voucher.status == 1){
                //this is lucky user
                //voucher_result
                var textSuccess = '<p class="phone" style="font-weight:bold; text-align:center">' + result.voucher.code + '</p>';
                textSuccess += '<p class="phone" style="font-weight:bold; text-align:center">' + result.user + '</p>';
                textSuccess += '<p style="text-align:center">Hãy mang đến nhà hàng khi bạn có nhu cầu sử dụng</p>';
                $("#voucher_result").html(textSuccess);
                $('#other_voucher_btn').show();
            }else{
                if($('#stepgetVou').val() == 0){
                    $("#voucher_result").html('<div style="text-align:center">Bạn đã tham gia sự kiện <br/> Chúc bạn may mắn lần sau</div>');
                    $('#other_voucher_btn').show();
                }else{
                    $("#voucher_result").html('<p class="text-align:center">Chúc bạn may mắn lần sau</p>');
                    $('#other_voucher_btn').show();
                }
            }
            $('#playInfo').hide();
            $('#verifycation_code').hide();
            $('#revice_voucher_btn').hide();
            $('#revice_voucher_btn').hide();
            $('#voucher_result').show();
        }
    }

    function checkPhoneNumber(phone) {
        var data = {
            "user": {
                "phone": phone,
                "coupon_id": $("#couponId").val()
            }
        };

        $.ajax({
            type: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            async:false,
            url: URL_MSG,
            dataType: 'json',
            data: JSON.stringify(data),
            success: function (msg) {
                if(msg.status != undefined){
                    if(msg.status == 0){
                        //in this case, user has not been registered, show screen for inputing verification code
                        var fullName = $('#playname').val();
                        $('#stepgetVou').val(1);
                        showConfirmFunction(fullName, phone);
                    } else if(msg.status == 1){
                        //user has got voucher before
                        showResult(msg);
                    }
                }
                else{
                    alert(msg[0].errors);
                }

            }, error: function (jqXHR, msg, error) {
                alert(jqXHR.responseJSON.errors);
                return msg;
            }
        });
    }

    function showConfirmFunction(fullName, phone) {
        $('#phone_val').html(phone);
        $('#fullNameVal').html(fullName);
        $('#playInfo').fadeOut();
        $('#verifycation_code').slideToggle();
        $('#revice_voucher_btn').attr("disabled", true);
    }

    function resendSMS() {
        var phone = $('#playphone').val();
        var data = {
            "user": {
                "phone": phone
            }
        };

        $.ajax({
            type: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            async:false,
            url: URL_ResendSMS,
            dataType: 'json',
            data: JSON.stringify(data),
            success: function (msg) {
            }, error: function (jqXHR, msg, error) {
                if(jqXHR.status == 200){
                    alert('Hệ thống đã gửi tin nhắn xác nhận thành công, bạn vui lòng kiểm tra lại tin nhắn');
                }else{
                    alert(jqXHR.responseJSON.errors);
                }
                return msg;
            }
        });
    }

    function showModalSample(title, description, price) {
        $('#titlePopup').html(title);
        $('#modal_until').modal('toggle');
    }

    var objAnchor;
    function showModalPlayAgame(obj, src, couponId) {
        var nextElement = $(obj).find('.coupon-description');
        var description = nextElement.val();
        $('#playphone').val("");
        $('#playname').val("");
        $("#couponId").val(couponId);
        $('#playInfo').hide();
        $('#play_agame_btn').show();
        $('#verifycation_code').hide();
        $('#revice_voucher_btn').hide();
        $('#stepgetVou').val(0);
        $('#modal_have_voucher').modal('toggle');
        var img = '';
        $('#modal_img').html('<img class="img-responsive" width="100%" src=" ' + src +'" />');
        var voucherDescription = "" + description +"";
        $("#voucherDescription").html(voucherDescription);
    }

    function showModalNoVoucher(src) {
        var img = '';
        $('#modal_img_no').html(img);
        $('#modal_no_voucher').modal('toggle');
    }
}