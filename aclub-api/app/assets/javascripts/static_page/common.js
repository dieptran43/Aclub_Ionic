$(document).ready(function(){
	
	//expand main submenu
    $('.expand-main-menu').click(function() {
        if ($('.main-menu').hasClass('menu-tiny')) {
			$(this).removeClass('active')
            $('.main-menu').removeClass('menu-tiny');
			$('.main-menu').slideUp();
			$('.main-navigator').addClass('header-pc');
        } else {
			$(this).addClass('active');
            $('.main-menu').addClass('menu-tiny');
			$('.main-menu').slideDown();
			$('.main-navigator').removeClass('header-pc');
        }
        return true;
    });
	
	//heartslider
	$('#heartslider').owlCarousel({
		items:1,
		loop:true,
		margin:0,
		nav:false,
		dots:false,
		autoplay:true,
    	autoplayTimeout:4000,
		autoplaySpeed:1000,
    	autoplayHoverPause:true,
		navText:false,
		animateOut: 'fadeOut',
    	animateIn: 'fadeIn',
		onInitialize: function (event) {
        if ($('.owl-carousel .hs-item').length <= 1) {
			   this.settings.loop = false;
			}
		}
	});
	
	//brandslider
	$('#brandslider').owlCarousel({
		loop:true,
		margin:0,
		nav:true,
		dots:false,
		autoplay:true,
    	autoplayTimeout:5000,
		autoplaySpeed:1000,
    	autoplayHoverPause:true,
		navText:false,
		responsiveClass:true,
		responsive:{
			0:{
				items:1
			},
			534:{
				items:2
			},
			992:{
				items:3
			}
		},
		onInitialize: function (event) {
        if ($('.owl-carousel .mb-item').length <= 1) {
			   this.settings.loop = false;
			}
		}
	});
	
	//expand submenu
    $('.expand-menu').click(function() {
        if ($('.menu').hasClass('menu-tiny')) {
			$(this).removeClass('active')
            $('.menu').removeClass('menu-tiny');
			$('.menu').slideUp();
			$('.navigator').addClass('header-pc');
        } else {
			$(this).addClass('active');
            $('.menu').addClass('menu-tiny');
			$('.menu').slideDown();
			$('.navigator').removeClass('header-pc');
        }
        return true;
    });
	
	//stoneslider
	$('#stoneslider').owlCarousel({
		items:1,
		loop:true,
		margin:0,
		nav:false,
		dots:true,
		autoplay:true,
    	autoplayTimeout:5000,
		autoplaySpeed:1000,
    	autoplayHoverPause:true,
		navText:false,
		animateOut: 'fadeOut',
    	animateIn: 'fadeIn',
		onInitialize: function (event) {
        if ($('.owl-carousel .stone-item').length <= 1) {
			   this.settings.loop = false;
			}
		}
	});
	
	// button top
	$('.go-top').click(function(){
		$("html, body").animate({scrollTop: $('body').offset().top}, 700);
		return false;
	});
	
	//footer menu mobile click
    $('.footer-label .fa').click(function() {
		var grand = $(this).parent().parent();
        if ($(this).hasClass("fa-plus")) {
			$('.footer .footer-label .fa').removeClass("fa-minus").addClass("fa-plus");
	    	$('.footer-content',$('.footer')).slideUp();
            $(this).removeClass("fa-plus");
			$(this).addClass("fa-minus");
			$('.footer-content',$(grand)).slideDown();
        } else {
            $(this).removeClass("fa-minus");
			$(this).addClass("fa-plus");
			$('.footer-content',$(grand)).slideUp();
        }
        return false;
    });
	
	//galleryslider
	$('#galleryslider').owlCarousel({
		loop:true,
		margin:0,
		nav:false,
		dots:false,
		autoplay:true,
    	autoplayTimeout:5000,
		autoplaySpeed:1000,
    	autoplayHoverPause:true,
		navText:false,
		responsiveClass:true,
		responsive:{
			0:{
				items:1
			},
			534:{
				items:2
			},
			1200:{
				items:4
			}
		},
		onInitialize: function (event) {
        if ($('.owl-carousel .gallery-item').length <= 1) {
			   this.settings.loop = false;
			}
		}
	});

});