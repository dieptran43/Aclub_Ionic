if(typeof(rootUrl) !== 'undefined') {
    $(document).ready(function () {
        $('#close_dialog').click(function () {
            $('#modal_have_voucher').modal('hide');
        });

        $('#modal_have_voucher').on('hidden.bs.modal', function (e) {
            $('#playInfo').hide();
            $('#play_agame_btn').show();
        });
    });

    function showModal(obj, src, menu_name) {
        var nextElement = $(obj).find('.menu-description');
        var listComponent = nextElement.val().split('|');
        var description = '';
        var price = $(obj).find('.price').text();
        console.log(price);
        for(i=0;i<listComponent.length;i++){
            description += '<p>';
            description += listComponent[i];
            description += '</p>';
        }

        description += '<p>' + price + '</p>';

        $('#playInfo').hide();
        $('#modal_have_voucher').modal('toggle');
        $('#modal_have_voucher h4.modal-title').html(menu_name);
        var img = '';
        $('#modal_img').html('<img class="img-responsive" width="100%" src=" ' + src +'" />');
        var voucherDescription = "" + description +"";
        $("#voucherDescription").html(voucherDescription);
    }
}