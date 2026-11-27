/* Login page behaviour (jQuery) */
(function ($) {
    'use strict';

    $(function () {
        var $password = $('#txtPassword');

        // Show / hide password
        $('#btnTogglePassword').on('click', function () {
            var isHidden = $password.attr('type') === 'password';
            $password.attr('type', isHidden ? 'text' : 'password');
            $(this).find('i').toggleClass('bi-eye bi-eye-slash');
        });

        // Prevent double submit once client validation passes
        $('#Login').on('submit', function () {
            if (typeof Page_IsValid === 'undefined' || Page_IsValid) {
                setTimeout(function () {
                    $('#btnLogin').prop('disabled', true).val('Signing in...');
                }, 0);
            }
        });
    });
})(jQuery);
