//= require jquery
//= require jquery-migrate-min
//= require jquery_ujs
//= require jquery-ui
//= require autocomplete-rails
//= require vendor
//= require jquery.dataTables_ext
//= require_tree ./design
//= require_tree ./extra
//= require_tree ./lib

//= require underscore

//= require js-routes
// require angular
//= require unstable/angular
// require angular-resource
//= require unstable/angular-resource
//= require ng-rails-csrf
//= require angular-i18n
//= require_tree ./angularjs
//= require moment

// require soundmanager2
//= require soundmanager2-nodebug-jsmin

//= require_self

function disableNotifierCbx(global_cbx) {
  if ($(global_cbx).attr('checked')) {
    $('.notify_cbx').removeAttr('disabled');
    $('.notify_cbx').each(function(i,el) { $(el).prev().removeAttr('disabled'); })
  } else {
    $('.notify_cbx').attr('disabled', 'disabled');
    $('.notify_cbx').each(function(i,el) { $(el).prev().attr('disabled', 'disabled'); })
  }
}

$(document).ready(function() {
  // setup all placeholders on page
  $('input[placeholder], textarea[placeholder]').placeholder();


  $('input.user_role_chbx').click(function() {
      var current = $(this);
      current.parent().find('input.user_role_chbx').each(function(i,el) {
          if ($(el).attr('id') != current.attr('id')) {
              $(el).removeAttr('checked');
          }
      });
  });

  $('#settings_notifier_can_notify').click(function() {
      disableNotifierCbx($(this));
  });

  $('div.information > div.profile > a').on('click', function(e) {
      e.preventDefault();
  });

  $('.more_activities').on('click', function(){
    var button = $(this);
    $.ajax({
      type: 'GET',
      url: button.attr("href"),
      success: function(data){
                      button.fadeOut('slow').after(data);
                      button.remove();
                      updateTime();
                    }
     });
    return false;
  });

  $('#description-top .git_help').click(function() {
    $('#git_help_data').toggle();
  });

  $(".toggle_btn").click(function() {
    var target = $( $(this).attr('data-target') );
    //target.toggle();
    if ( target.css('visibility') == 'hidden' ) {
      target.css('visibility', 'visible');
    } else {
      target.css('visibility', 'hidden');
    }
    return false;
  });

  window.updateTime = function () {
    $('.datetime_moment').each(function() {
      $(this).html(moment($(this).attr('origin_datetime'), 'X').fromNow());
    });
  };

  updateTime();
  setInterval( updateTime, 15000 );

  window.updatePagination = function(link) {
    var page = parseInt($('.pagination .current').text());
    if (link.hasClass('next_page')) {
      page += 1;
    } else {
      if (link.hasClass('previous_page')) {
        page -= 1;
      } else {
        page = link.text();
      }
    }
    $('.pagination .current').html(page);
  };

  window.isSearchUser = null;
  window.search_items = function(path, fdata, dom) {
    if (window.isSearchUser != null) { window.isSearchUser.abort(); }
    window.isSearchUser = $.ajax({
      type: 'GET',
      url: path,
      data: fdata,
      success: function(data) {
        dom.html(data);
        updateTime();
      }
    });
    return false;
  }
});
