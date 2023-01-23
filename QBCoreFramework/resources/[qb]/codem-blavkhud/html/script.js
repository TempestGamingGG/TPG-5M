var poscan = null;
var poszirh = null;
var poshunger = null;
var possu = null;
var posbenzin = null;
var posrpm = null;
let rightInterval = null;
let leftInterval = null;
let serverid = null;
let currentHud = "radialhud";
let hideHud = false;
let cinematicMode = false;
let insettings = false;
let hideonfoot = false;
let compassPos = null;
let invehicle = false;
let talkingRadius = null;
let hudsecti = null;
let lastmoney = 0;
let lastbank = 0;


$('.venice-hud').css('display', 'none');
$('.venice-hud-walk').css('display', 'none');
$('.text-hud-map-walk').css('display', 'none');
$('#text-hud-map').css('display', 'none');
$('.text-hud-icons-onfoot').css('display', 'none');
$('#radial-hud-map').css('display', 'none');
$('.radial-hud-map-walk').css('display', 'none');

setTimeout(() => {
  $.post("https://codem-blavkhud/Ready", JSON.stringify({}));
  document.querySelector(".radialmic").style.strokeDasharray = `${(
    100 / 1
  ).toFixed(1)}, 100`;
}, 1000);

$(document).on("click", "#exit", function () {
  $.post("https://codem-blavkhud/close");
  $(".settings").hide(0);
  $("body").css("backgroundColor", "rgba(0,0,0,0.0)");
  if (!hideHud && !cinematicMode) {
    $(".all").css("display", "block");
  }
});

$(document).on("click", "#showcompass", function () {
  $.post("https://codem-blavkhud/showcompass");

});

$(document).on("click", "#hidecompass", function () {
  $.post("https://codem-blavkhud/hidecompass");

});

$(document).on("click", ".options-mph", function () {
  $.post("https://codem-blavkhud/mph");

});


$(document).on("click", ".compass-onmap-img", function () {
  $.post("https://codem-blavkhud/conkmpass-onmap");

});

$(document).on("click", ".compass-bottom", function () {
  $.post("https://codem-blavkhud/compass-bottom");

});
$(document).on("click", ".compass-top-img", function () {
  $.post("https://codem-blavkhud/compass-top");
});



$(document).on("click", ".options-kmh", function () {
  $.post("https://codem-blavkhud/kmh");

});


$(document).on("click", "#hidehud", function () {
  $.post("https://codem-blavkhud/hidehud");
});

$(document).on("click", "#radialhud", function () {
  $.post("https://codem-blavkhud/radialhud");
});

$(document).on("click", "#venicehud", function () {
  $.post("https://codem-blavkhud/venicehud");
});

$(document).on("click", "#texthud", function () {
  $.post("https://codem-blavkhud/texthud");
});


$(document).on("click", "#showhud", function () {
  $.post("https://codem-blavkhud/showhud");
});

$(document).on("click", "#enable-cinematic", function () {
  $.post("https://codem-blavkhud/cinematicmode");
});

$(document).on("click", "#disable-cinematic", function () {
  $.post("https://codem-blavkhud/disablecinematicmode");
});

window.addEventListener("message", function (event) {
  var item = event.data;

  if (typeof item.hideHud !== "undefined") {
    if (item.hideHud == true) {
      $(".container").fadeOut();
    } else {
      $(".container").fadeIn();
    }
  }

  if (typeof item.health !== "undefined") {
    $('.text-hud-health').text(item.health + "%");
    document.querySelector(
      ".radialhealth"
    ).style.strokeDasharray = `${item.health}, 100`;
    document.querySelector(
      ".radialhealthwalk"
    ).style.strokeDasharray = `${item.health}, 100`;

    var can = item.health / 99;
    poscan = can;
  }
  if (typeof item.min !== "undefined") {
    $(".saat").text(item.saat + ":" + item.min);
    $(".saattext").text(item.saat + ":" + item.min);
    $(".saatvenice").text(item.saat + ":" + item.min);
  }
  if (typeof item.streetName !== "undefined") {
    if (item.streetName.length > 15) {
      item.streetName = item.streetName.slice(0, 12);

      item.streetName = item.streetName + "...";
    }
    $(".streetname").text(item.streetName);
    $(".streetnametext").text(item.streetName);
    $(".streetnamevenice").text(item.streetName);

  }

  if (typeof item.changeSpeedUnit !== "undefined") {
    $(".kmhtext").text(item.changeSpeedUnit);
  }

  if (typeof item.armour !== "undefined") {
    $('.text-hud-armor').text(item.armour + "%");

    document.querySelector(
      ".radialarmor"
    ).style.strokeDasharray = `${item.armour}, 100`;
    document.querySelector(
      ".radialarmorwalk"
    ).style.strokeDasharray = `${item.armour}, 100`;

    var zirh = item.armour / 99;
    poszirh = zirh;
  }
  if (typeof item.stress !== "undefined") {

    $('.text-hud-stress').text(item.stress.toFixed(1) + "%");

    // document.querySelector(
    //   ".radialarmor"
    // ).style.strokeDasharray = `${item.armour}, 100`;
    document.querySelector(
      ".radialstresswalk"
    ).style.strokeDasharray = `${item.stress.toFixed(0)}, 100`;
    $(".playerId").html(item.stress.toFixed(0));
    // var zirh = item.armour / 99;
    // poszirh = zirh;
  }


  if (typeof item.job !== "undefined") {

    $('.playerhudjob').text(item.job);
  }

  if (typeof item.bank !== "undefined") {
    lastbank = item.bank;





  }



  if (typeof item.money !== "undefined") {

    lastmoney = item.money;
  }

  if (typeof item.hudStatus !== "undefined") {
    if (!item.hudStatus) {
      $('.playerhud').css('display', 'none');
    }
  }



  if (typeof item.oxygen !== "undefined") {
    $('.text-hud-stamina').text(item.oxygen.toFixed(0) + "%");

    document.querySelector(
      ".radialstamina"
    ).style.strokeDasharray = `${item.oxygen.toFixed(0)}, 100`;

    $(".venicestamina").text(item.oxygen.toFixed(0));
  }

  if (typeof item.food !== "undefined") {


    $('.text-hud-hunger').text(item.food.toFixed(1) + "%");

    document.querySelector(
      ".radialhunger"
    ).style.strokeDasharray = `${item.food}, 100`;
    document.querySelector(
      ".radialhungerwalk"
    ).style.strokeDasharray = `${item.food}, 100`;

    var yemek = item.food / 99;

    poshunger = yemek;
  }

  if (typeof item.water !== "undefined") {
    $('.text-hud-water').text(item.water.toFixed(1) + "%");

    document.querySelector(
      ".radialthirsty"
    ).style.strokeDasharray = `${item.water}, 100`;
    document.querySelector(
      ".radialthirstywalk"
    ).style.strokeDasharray = `${item.water}, 100`;

    var su = item.water / 99;
    possu = su;
  }

  if (typeof item.preferences !== "undefined") {
    if (item.preferences.hud == "venicehud") {

      $(".radial-hud").css("display", "none");
      $(".venice-hud").css("display", "block");
      $(".text-hud").css("display", "none");
      $(".venice-hud-walk").css("display", "none");
      $(".maphud").css("display", "block");

      $(".health-bar-walk").css("display", "block");
      $(".hunger-bar-walk").css("display", "block");
      $(".armor-bar-walk").css("display", "block");
      $(".thirsty-bar-walk").css("display", "block");

      $('#radialhud').css("opacity", 0.6)
      $('#texthud').css("opacity", 0.6)
      $('#venicehud').css("opacity", 1)

    } else if (item.preferences.hud == "radialhud") {


      $('#radialhud').css("opacity", 1)
      $('#venicehud').css("opacity", 0.6)
      $('#texthud').css("opacity", 0.6)


      $(".radial-hud").css("display", "block");
      $(".maphud").css("display", "none");

      $(".health-bar-walk").css("display", "none");
      $(".hunger-bar-walk").css("display", "none");
      $(".armor-bar-walk").css("display", "none");
      $(".thirsty-bar-walk").css("display", "none");


      $(".venice-hud").css("display", "none");
      $(".text-hud").css("display", "none");

    } else if (item.preferences.hud == "texthud") {

      $('#radialhud').css("opacity", 0.6)
      $('#texthud').css("opacity", 1)
      $('#venicehud').css("opacity", 0.6)
      $(".text-hud").css("display", "block");
      $(".radial-hud").css("display", "none");
      $(".venice-hud").css("display", "none");
    }

    if (item.preferences.hide) {
      $('#showhud').css('display', 'block');
      $('#hidehud').css('display', 'none');

      $(".all").css("display", "none");
    } else {
      $('#showhud').css('display', 'none');
      $('#hidehud').css('display', 'block');
      if (!insettings) {
        $(".all").css("display", "block");
      }

    }

    if (item.preferences.compassPos == "top") {
      $('.compassgenel').css("top", "2vh")
      $('.bar2').css("top", "-0.5vh")
      $('.compassgenel').prop('style').removeProperty('bottom')
      $('.compassgenel').css("left", "50%")
      $('.compassgenel').css("transform", "translateX(-50%)")
    } else if (item.preferences.compassPos == "bottom") {
      $('.compassgenel').css("top", "95vh")
      $('.bar2').css("top", "90vh")
      $('.compassgenel').css("left", "50%")
      $('.compassgenel').css("transform", "translateX(-50%)")
    } else if (item.preferences.compassPos == "onmap") {
      $('.compassgenel').css("top", "71vh")
      $('.compassgenel').css("left", "8.5vh")
      $('.compassgenel').css("transform", "translateX(0%)")
      if (item.preferences.hud == "venicehud") {
        if ($("#maphud").attr("src") == "./Venice-Mode/on-walk-hud.png") {
          $('.compassgenel').css("top", "85vh")
        }
      } else if (item.preferences.hud == "texthud") {
        if ($("#text-hud-map").attr("src") == "./Text-Mode/onwalk-hud.png") {
          $('.compassgenel').css("top", "90vh")
        }
      } else if (item.preferences.hud == "radialhud") {

        $('.compassgenel').css("top", "90vh")

      }
    }



    if (item.preferences.speedtype == "kmh") {
      $('#speed-unit-text').text("km/h")
    } else {
      $('#speed-unit-text').text("mph")
    }

    if (item.preferences.cinematic) {
      $('#disable-cinematic').css('display', 'block');
      $('#enable-cinematic').css('display', 'none');
      $(".all").css("display", "none");

    } else {

      $('#disable-cinematic').css('display', 'none');
      $('#enable-cinematic').css('display', 'block');
      if (item.preferences.hide) {

        $(".all").css("display", "none");
      } else {
        if (!insettings) {

          $(".all").css("display", "block");
        }

      }
    }

    if (item.preferences.showcompass) {
      $('.compassgenel').css("display", "block");
      $('#showcompass').css('display', 'none');
      $('#hidecompass').css('display', 'block');

    } else {
      $('.compassgenel').css("display", "none");
      $('#showcompass').css('display', 'block');
      $('#hidecompass').css('display', 'none');
    }
    cinematicMode = item.preferences.cinematic;
    hideHud = item.preferences.hide
    currentHud = item.preferences.hud;
    compassPos = item.preferences.compassPos;


    if (item.preferences.hud == 'venicehud') {
      hudsecti = item.preferences.hud
      $('.text-hud-icons-vehicle').css('display', 'none');
      $('#text-hud-map').css('display', 'none');
      $('.text-hud-icons-onfoot').css('display', 'none');
      $('.text-hud-map-walk').css('display', 'none');
      $('#radial-hud-map').css('display', 'none');
      $('.radial-hud-map-walk').css('display', 'none');

      if (invehicle) {
        $('.venice-hud').css('display', 'block')
        $('.venice-hud-walk').css('display', 'none')

        $('.micbar').css('display', 'none')
      } else {
        $('.venice-hud').css('display', 'none')

        $('.venice-hud-walk').css('display', 'block')
      }
      $('.micbar').css('display', 'none')

    }
    if (item.preferences.hud == 'texthud') {

      hudsecti = item.preferences.hud

      $('#radial-hud-map').css('display', 'none');
      $('.radial-hud-map-walk').css('display', 'none');
      $('.allhudmicon').css('display', 'none')
      $('.venice-hud-walk').css('display', 'none')
      $('.venice-hud').css('display', 'none')
      if (invehicle) {
        $('.text-hud-icons-vehicle').css('display', 'block');
        $('#text-hud-map').css('display', 'block');
        $('.text-hud-icons-onfoot').css('display', 'none');
        $('.text-hud-map-walk').css('display', 'none');
      } else {
        $('.text-hud-icons-vehicle').css('display', 'none');
        $('#text-hud-map').css('display', 'none');
        $('.text-hud-icons-onfoot').css('display', 'block');
        $('.text-hud-map-walk').css('display', 'block');
      }
    }
    if (item.preferences.hud == 'radialhud') {
      hudsecti = item.preferences.hud
      $('#radial-hud-map').css('display', 'none');
      $('.radial-hud-map-walk').css('display', 'none');
      $('.allhudmicon').css('display', 'none')
      $('.text-hud-icons-vehicle').css('display', 'none');
      $('#text-hud-map').css('display', 'none');
      $('.text-hud-icons-onfoot').css('display', 'none');
      $('.text-hud-map-walk').css('display', 'none');
      $('.micbar').css('display', 'none')
      $('.venice-hud-walk').css('display', 'none')
      $('.venice-hud').css('display', 'none')
      if (invehicle) {


        $('#radial-hud-map').css('display', 'block');
        $('.radial-hud-map-walk').css('display', 'none');
      } else {
        $('#radial-hud-map').css('display', 'none');
        $('.radial-hud-map-walk').css('display', 'block');

      }
    }
  }



  if (typeof item.invehicle !== "undefined") {
    if (hideonfoot) {
      if (item.invehicle) {
        $(".radial-id").css("display", "none");
        $(".saat").css("display", "block");
        $(".streetname").css("display", "block");
        $(".health-progress-bar").css("display", "block");
        $(".armor-progress-bar").css("display", "block");
        $(".radialmic").css("display", "block");
        $(".thirsty-progress-bar").css("display", "block");
        $(".hunger-progress-bar").css("display", "block");

        $(".stamina-progress-bar").css("display", "none");
        $(".health-progress-bar-walk").css("display", "none");
        $(".hunger-progress-bar-walk").css("display", "none");
        $(".armor-progress-bar-walk").css("display", "none");
        $(".thirsty-progress-bar-walk").css("display", "none");
        $(".mic-progress-bar-walk").css("display", "none");
        $(".mic-progress-bar").css("display", "block");

        $(".saattext").css("display", "block");
        $(".streetnametext").css("display", "block");
        $("#radial-hud-map").css("display", "none");
        $(".radial-hud-map-walk").css("display", "none");
        $(".allhudmicon").css("display", "none");
        $(".venice-hud-walk").css("display", "none");
        $(".venice-hud").css("display", "none");

        $(".text-hud-icons-vehicle").css("display", "none");
        $("#text-hud-map").css("display", "none");
        $(".text-hud-icons-onfoot").css("display", "none");
        $(".text-hud-map-walk").css("display", "none");
        $("#radial-hud-map").css("display", "none");
        $(".radial-hud-map-walk").css("display", "none");
        $("#radial-hud-map").css("display", "none");
        $(".radial-hud-map-walk").css("display", "none");
        $(".allhudmicon").css("display", "none");
        $(".text-hud-icons-vehicle").css("display", "none");
        $("#text-hud-map").css("display", "none");
        $(".text-hud-icons-onfoot").css("display", "none");
        $(".text-hud-map-walk").css("display", "none");
        $(".micbar").css("display", "none");
        $(".venice-hud-walk").css("display", "none");
        $(".venice-hud").css("display", "none");

        if (hudsecti == "texthud") {
          $(".text-hud-icons-vehicle").css("display", "block");
          $("#text-hud-map").css("display", "block");
          $(".text-hud-icons-onfoot").css("display", "none");
          $(".text-hud-map-walk").css("display", "none");
        }

        if (hudsecti == "radialhud") {
          $("#radial-hud-map").css("display", "block");
          $(".radial-hud-map-walk").css("display", "none");
        }

        if (hudsecti == "venicehud") {
          $(".venice-hud").css("display", "block");
          $(".venice-hud-walk").css("display", "none");
        }


        if (compassPos == "onmap") {
          if (hideonfoot) {
            if (currentHud == "venicehud") {
              if ($("#maphud").attr("src") == "./img/Map-HUD.png") {
                $(".compassgenel").css("top", "71vh");
              }
            } else if (currentHud == "texthud") {
              if ($("#text-hud-map").attr("src") == "./Text-Mode/Map-HUD.png") {
                $(".compassgenel").css("top", "71vh");
              }
            } else if (currentHud == "radialhud") {
              $(".compassgenel").css("top", "71vh");
            }
          }
        }
      } else {
        $(".saat").css("display", "none");
        $(".streetname").css("display", "none");
        $(".radial-id").css("display", "block");

        $(".health-progress-bar").css("display", "none");
        $(".armor-progress-bar").css("display", "none");
        $(".radialmic").css("display", "none");
        $(".thirsty-progress-bar").css("display", "none");
        $(".hunger-progress-bar").css("display", "none");

        $(".mic-progress-bar").css("display", "none");

        $(".stamina-progress-bar").css("display", "block");
        $(".health-progress-bar-walk").css("display", "block");
        $(".hunger-progress-bar-walk").css("display", "block");
        $(".armor-progress-bar-walk").css("display", "block");
        $(".thirsty-progress-bar-walk").css("display", "block");
        $(".mic-progress-bar-walk").css("display", "block");
        $(".text-hud-icons-vehicle").css("display", "none");

        $(".saattext").css("display", "none");
        $(".streetnametext").css("display", "none");

        $(".text-hud-icons-vehicle").css("display", "none");
        $("#text-hud-map").css("display", "none");
        $(".text-hud-icons-onfoot").css("display", "none");
        $(".text-hud-map-walk").css("display", "none");
        $("#radial-hud-map").css("display", "none");
        $(".radial-hud-map-walk").css("display", "none");
        $("#radial-hud-map").css("display", "none");
        $(".radial-hud-map-walk").css("display", "none");
        $(".allhudmicon").css("display", "none");
        $(".text-hud-icons-vehicle").css("display", "none");
        $("#text-hud-map").css("display", "none");
        $(".text-hud-icons-onfoot").css("display", "none");
        $(".text-hud-map-walk").css("display", "none");
        $(".micbar").css("display", "none");
        $(".venice-hud-walk").css("display", "none");
        $(".venice-hud").css("display", "none");

        if (hudsecti == "venicehud") {
          $(".venice-hud").css("display", "none");
          $(".venice-hud-walk").css("display", "block");
        }

        if (hudsecti == "texthud") {
          $(".text-hud-icons-vehicle").css("display", "none");
          $("#text-hud-map").css("display", "none");
          $(".text-hud-icons-onfoot").css("display", "block");
          $(".text-hud-map-walk").css("display", "block");
        }

        if (hudsecti == "radialhud") {
          $("#radial-hud-map").css("display", "none");
          $(".radial-hud-map-walk").css("display", "block");
        }


        if (compassPos == "onmap") {
          if (currentHud == "venicehud") {
            if ($("#maphud").attr("src") == "./Venice-Mode/on-walk-hud.png") {
              $(".compassgenel").css("top", "85vh");
            }
          } else if (currentHud == "texthud") {
            if (
              $("#text-hud-map").attr("src") == "./Text-Mode/onwalk-hud.png"
            ) {
              $(".compassgenel").css("top", "90vh");
            }
          } else if (currentHud == "radialhud") {
            if (
              $("#radial-hud-map").attr("src") == "./Radial-Mode/onwalk-hud.png"
            ) {
              $(".compassgenel").css("top", "90vh");
            }
          }
        }
      }
      invehicle = item.invehicle;

      if (item.talking == true) {
        if (hudsecti == "texthud") {
          if (!invehicle) {
            $(".allhudmicontextwalk").css("display", "block");
            $(".allhudmicon").css("display", "none");
          } else {
            $(".allhudmicontext").css("display", "block");
          }
        } else if (hudsecti == "venicehud") {
          if (!invehicle) {
            $(".allhudmiconvenicewalk").css("display", "block");
            $(".allhudmiconvenice").css("display", "none");
          } else {
            $(".allhudmiconvenicewalk").css("display", "none");
            $(".allhudmiconvenice").css("display", "block");
          }
        } else {
          if (!invehicle) {
            $(".allhudmiconradial").css("display", "none");
            $(".allhudmiconradialwalk").css("display", "block");
          } else {
            $(".allhudmiconradial").css("display", "block");
            $(".allhudmiconradialwalk").css("display", "none");
          }
        }
      } else {
        $(".allhudmicon").css("display", "none");
        $(".allhudmicontext").css("display", "none");
        $(".allhudmiconradial").css("display", "none");
        $(".allhudmiconradialwalk").css("display", "none");
        $(".allhudmicontextwalk").css("display", "none");
        $(".allhudmicontext").css("display", "none");
        $(".allhudmiconvenicewalk").css("display", "none");
        $(".allhudmiconvenice").css("display", "none");
      }
    } else {
      $(".radial-id").css("display", "none");
      $(".saat").css("display", "block");
      $(".streetname").css("display", "block");
      $(".health-progress-bar").css("display", "block");
      $(".armor-progress-bar").css("display", "block");
      $(".radialmic").css("display", "block");
      $(".thirsty-progress-bar").css("display", "block");
      $(".hunger-progress-bar").css("display", "block");

      $(".stamina-progress-bar").css("display", "none");
      $(".health-progress-bar-walk").css("display", "none");
      $(".hunger-progress-bar-walk").css("display", "none");
      $(".armor-progress-bar-walk").css("display", "none");
      $(".thirsty-progress-bar-walk").css("display", "none");
      $(".mic-progress-bar-walk").css("display", "none");
      $(".mic-progress-bar").css("display", "block");

      $(".saattext").css("display", "block");
      $(".streetnametext").css("display", "block");
      $("#radial-hud-map").css("display", "none");
      $(".radial-hud-map-walk").css("display", "none");
      $(".allhudmicon").css("display", "none");
      $(".venice-hud-walk").css("display", "none");
      $(".venice-hud").css("display", "none");

      $(".text-hud-icons-vehicle").css("display", "none");
      $("#text-hud-map").css("display", "none");
      $(".text-hud-icons-onfoot").css("display", "none");
      $(".text-hud-map-walk").css("display", "none");
      $("#radial-hud-map").css("display", "none");
      $(".radial-hud-map-walk").css("display", "none");
      $("#radial-hud-map").css("display", "none");
      $(".radial-hud-map-walk").css("display", "none");
      $(".allhudmicon").css("display", "none");
      $(".text-hud-icons-vehicle").css("display", "none");
      $("#text-hud-map").css("display", "none");
      $(".text-hud-icons-onfoot").css("display", "none");
      $(".text-hud-map-walk").css("display", "none");
      $(".micbar").css("display", "none");
      $(".venice-hud-walk").css("display", "none");
      $(".venice-hud").css("display", "none");

      if (hudsecti == "texthud") {
        $(".text-hud-icons-vehicle").css("display", "block");
        $("#text-hud-map").css("display", "block");
        $(".text-hud-icons-onfoot").css("display", "none");
        $(".text-hud-map-walk").css("display", "none");
      }

      if (hudsecti == "radialhud") {
        $("#radial-hud-map").css("display", "block");
        $(".radial-hud-map-walk").css("display", "none");
      }

      if (hudsecti == "venicehud") {
        $(".venice-hud").css("display", "block");
        $(".venice-hud-walk").css("display", "none");
      }


      if (compassPos == "onmap") {
        if (hideonfoot) {
          if (currentHud == "venicehud") {
            if ($("#maphud").attr("src") == "./img/Map-HUD.png") {
              $(".compassgenel").css("top", "71vh");
            }
          } else if (currentHud == "texthud") {
            if ($("#text-hud-map").attr("src") == "./Text-Mode/Map-HUD.png") {
              $(".compassgenel").css("top", "71vh");
            }
          } else if (currentHud == "radialhud") {
            $(".compassgenel").css("top", "71vh");
          }
        }
      }
      invehicle = true;
      if (item.talking == true) {
        if (hudsecti == "texthud") {
          if (!invehicle) {
            $(".allhudmicontextwalk").css("display", "block");
            $(".allhudmicon").css("display", "none");
          } else {
            $(".allhudmicontext").css("display", "block");
          }
        } else if (hudsecti == "venicehud") {
          if (!invehicle) {
            $(".allhudmiconvenicewalk").css("display", "block");
            $(".allhudmiconvenice").css("display", "none");
          } else {
            $(".allhudmiconvenicewalk").css("display", "none");
            $(".allhudmiconvenice").css("display", "block");
          }
        } else {
          if (!invehicle) {
            $(".allhudmiconradial").css("display", "none");
            $(".allhudmiconradialwalk").css("display", "block");
          } else {
            $(".allhudmiconradial").css("display", "block");
            $(".allhudmiconradialwalk").css("display", "none");
          }
        }
      } else {
        $(".allhudmicon").css("display", "none");
        $(".allhudmicontext").css("display", "none");
        $(".allhudmiconradial").css("display", "none");
        $(".allhudmiconradialwalk").css("display", "none");
        $(".allhudmicontextwalk").css("display", "none");
        $(".allhudmicontext").css("display", "none");
        $(".allhudmiconvenicewalk").css("display", "none");
        $(".allhudmiconvenice").css("display", "none");
      }
    }
  }


  if (typeof item.showVehiclePart !== "undefined") {
    if (item.showVehiclePart == true) {
      $(".onwalk").css("display", "none");
      $(".carhud").css("display", "block");
      $("#text").css("display", "block");
      $(".hizsvg").css("display", "block");
      $(".fuelsvg").css("display", "block");
      $(".icons").css("display", "block");
      $(".stress-progress-bar-walk").css("display", "none");
    } else if (item.showVehiclePart == false) {
      $(".carhud").css("display", "none");
      $(".onwalk").css("display", "block");
      $("#text").css("display", "none");
      $(".hizsvg").css("display", "none");
      $(".fuelsvg").css("display", "none");
      $(".icons").css("display", "none");
      $(".stress-progress-bar-walk").css("display", "block");
     
      
    }
  }

  if (typeof item.rightindicator !== "undefined") {
    if (item.rightindicator == "on") {
      let indicator = false;

      rightInterval = setInterval(() => {
        if (indicator == false) {
          $("#right-on").css("display", "block");
          indicator = true;
        } else {
          $("#right-on").css("display", "none");
          indicator = false;
        }
      }, 500);
    } else {
      if (rightInterval) {
        clearInterval(rightInterval);
        rightInterval = null;
      }
      $("#right-on").css("display", "none");
    }
  }

  if (typeof item.hazardlights !== "undefined") {
    if (item.hazardlights == "on") {

      if (rightInterval) {
        clearInterval(rightInterval);
        rightInterval = null;
      }
      if (leftInterval) {
        clearInterval(leftInterval);
        leftInterval = null;
      }
      let indicator1 = false;
      let indicator2 = false;
      setTimeout(() => {
        rightInterval = setInterval(() => {

          if (indicator1 == false) {
            $("#right-on").css("display", "block");
            indicator1 = true;
          } else {
            $("#right-on").css("display", "none");
            indicator1 = false;
          }
        }, 500);

        leftInterval = setInterval(() => {
          if (indicator2 == false) {


            $("#left-on").css("display", "block");
            indicator2 = true;
          } else {
            $("#left-on").css("display", "none");
            indicator2 = false;
          }
        }, 500);
      }, 150)

    } else {

      $(".hizsvg").css("display", "none");
      if (rightInterval) {
        clearInterval(rightInterval);
        rightInterval = null;
      }
      if (leftInterval) {
        clearInterval(leftInterval);
        leftInterval = null;
      }
      $("#right-on").css("display", "none");
      $("#left-on").css("display", "none");

    }
  }

  if (typeof item.leftindicator !== "undefined") {
    if (item.leftindicator == "on") {
      let indicator = false;

      leftInterval = setInterval(() => {
        if (indicator == false) {
          $("#left-on").css("display", "block");
          indicator = true;
        } else {
          $("#left-on").css("display", "none");
          indicator = false;
        }
      }, 500);
    } else {
      if (leftInterval) {
        clearInterval(leftInterval);
        leftInterval = null;
      }
      $("#left-on").css("display", "none");
    }
  }
  if (typeof item.handbrake !== "undefined") {
    if (item.handbrake) {
      $("#brakes-on").css("display", "block");
    } else {
      $("#brakes-on").css("display", "none");
    }
  }

  if (typeof item.seated !== "undefined") {
    if (item.seated == true) {
      $("#seatbelt-on").css("display", "block");
    } else if (item.seated == false) {
      $("#seatbelt-on").css("display", "none");
    }
  }
  if (typeof item.motor !== "undefined") {
    if (item.motor == 1) {
      $("#motoracik").css("display", "block");
      $("#motorkapali").fadeOut(100);
    } else {
      $("#motoracik").fadeOut(100);
      $("#motorkapali").fadeIn(100);
    }
  }
  if (typeof item.isiklar !== "undefined") {
    if (item.isiklar == "off") {
      $("#longlights-on").css("display", "none");
      $("#lights-on").css("display", "none");
    } else if (item.isiklar == "normal") {
      $("#lights-on").css("display", "block");
    } else if (item.isiklar == "high") {
      $("#longlights-on").css("display", "block");
    }
  }

  if (typeof item.hideseat !== "undefined") {
    if (item.hideseat == true) {
      $("#seatbelt-on").css("display", "none");
    }
  }
  if (typeof item.talking !== "undefined") {
    if (item.talking == true) {
      if (hudsecti == 'texthud') {
        if (!invehicle) {
          $('.allhudmicontextwalk').css('display', 'block')
          $('.allhudmicon').css('display', 'none')
        } else {

          $('.allhudmicontext').css('display', 'block')
        }

      } else if (hudsecti == 'venicehud') {
        if (!invehicle) {
          $('.allhudmiconvenicewalk').css('display', 'block')
          $('.allhudmiconvenice').css('display', 'none')
        } else {
          $('.allhudmiconvenicewalk').css('display', 'none')
          $('.allhudmiconvenice').css('display', 'block')
        }


      } else {
        if (!invehicle) {
          $('.allhudmiconradial').css('display', 'none')
          $('.allhudmiconradialwalk').css('display', 'block')

        } else {
          $('.allhudmiconradial').css('display', 'block')
          $('.allhudmiconradialwalk').css('display', 'none')
        }

      }
    } else {
      $('.allhudmicon').css('display', 'none')
      $('.allhudmicontext').css('display', 'none')
      $('.allhudmiconradial').css('display', 'none')
      $('.allhudmiconradialwalk').css('display', 'none')
      $('.allhudmicontextwalk').css('display', 'none')
      $('.allhudmicontext').css('display', 'none')
      $('.allhudmiconvenicewalk').css('display', 'none')
      $('.allhudmiconvenice').css('display', 'none')
    }
  }

  if (typeof item.speed !== "undefined") {
    let speed = item.speed;
    document.querySelector(".hizsvg").style.strokeDasharray = `${speed}, 400`;
    $("#text h1").text(item.speed);
  }
  if (typeof item.kimlik != "undefined") {
    $(".beyinyazi").text(item.kimlik);
  }

  if (typeof item.fuel !== "undefined") {
    posbenzin = (item.fuel * 150) / 100
  }

  if (typeof item.rpm !== "undefined") {
    var rpm = item.rpm / 1000;
    posrpm = rpm;
  }

  if (typeof item.pauseactive !== "undefined") {
    if (item.pauseactive == true) {
      $(".all").fadeOut();
    } else {
      if (!hideHud && !cinematicMode) {
        $(".all").fadeIn();
      }
    }
  }

  if (typeof item.cruised !== "undefined") {
    if (item.cruised == true) {
      $("#cruise-on").css("display", "block");
    } else if (item.cruised == false) {
      $("#cruise-on").css("display", "none");
    }
  }
  if (typeof item.setid !== "undefined") {
    serverid = item.setid;
    $('.radial-id-text').html(serverid);
    $('.text-server-id').html(serverid)

  }

  if (typeof item.talkingRadius !== "undefined") {
    talkingRadius = item.talkingRadius
    if (item.talkingRadius == 1) {
      $(".micbar-1").css("display", "block");
      $(".micbar-2").css("display", "none");
      $(".micbar-3").css("display", "none");
      $(".micbar-1-text").css("display", "block");
      $(".micbar-2-text").css("display", "none");
      $(".micbar-3-text").css("display", "none");
      if (!invehicle) {
        $(".venicemodemiclow").css("display", "block");
        $(".venicemodemichig").css("display", "none");
        $(".venicemodemicmid").css("display", "none");
      }

      document.querySelector(".radialmic").style.strokeDasharray = `${(
        100 / 3
      ).toFixed(1)}, 100`;
      document.querySelector(".radialmicwalk").style.strokeDasharray = `${(
        100 / 3
      ).toFixed(1)}, 100`;
    } else if (item.talkingRadius == 2) {
      $(".micbar-1").css("display", "block");
      $(".micbar-2").css("display", "block");
      $(".micbar-3").css("display", "none");

      $(".micbar-1-text").css("display", "block");
      $(".micbar-2-text").css("display", "block");
      $(".micbar-3-text").css("display", "none");
      if (!invehicle) {
        $(".venicemodemiclow").css("display", "block");
        $(".venicemodemichig").css("display", "none");
        $(".venicemodemicmid").css("display", "block");
      }

      document.querySelector(".radialmic").style.strokeDasharray = `${(
        100 / 2
      ).toFixed(1)}, 100`;
      document.querySelector(".radialmicwalk").style.strokeDasharray = `${(
        100 / 2
      ).toFixed(1)}, 100`;
    } else {
      $(".micbar-1").css("display", "block");
      $(".micbar-2").css("display", "block");
      $(".micbar-3").css("display", "block");

      $(".micbar-1-text").css("display", "block");
      $(".micbar-2-text").css("display", "block");
      $(".micbar-3-text").css("display", "block");

      if (!invehicle) {
        $(".venicemodemiclow").css("display", "block");
        $(".venicemodemichig").css("display", "block");
        $(".venicemodemicmid").css("display", "block");
      }


      document.querySelector(".radialmic").style.strokeDasharray = `${(
        100 / 1
      ).toFixed(1)}, 100`;
      document.querySelector(".radialmicwalk").style.strokeDasharray = `${(
        100 / 1
      ).toFixed(1)}, 100`;
    }


  }
  if (typeof item.hudsettings !== "undefined") {
    if (item.hudsettings) {
      insettings = true
      $(".settings").show(0);
      $(".all").css("display", "none");
    }
  }

  if (typeof item.plyHeading !== "undefined") {
    if (item.plyHeading !== undefined) {
      bar = document.getElementsByTagName("svg")[0];
      bar.setAttribute("viewBox", "" + (item.plyHeading - 90) + " 0 180 5");
      heading = document.getElementsByTagName("svg")[1];
      heading.setAttribute("viewBox", "" + (item.plyHeading - 90) + " 0 180 1.5");
    }
  }

  if (typeof item.hideonfoot !== "undefined") {
    hideonfoot = item.hideonfoot
  }
});

var lastcan = null;
var lastzirh = null;
var lastyemek = null;
var lastsu = null;
var lastbenzin = null;
var lastrpm = null;
setInterval(function () {
  if (poscan != lastcan) {
    if (poscan >= 1.0) {
      poscan = 1.0;
    }
    lastcan = poscan;

    var healthbar = new ProgressBar.Path("#health-bar2", {
      easing: "easeInOut",
      duration: 0,
    });
    var healthbar2 = new ProgressBar.Path("#health-bar44", {
      easing: "easeInOut",
      duration: 0,
    });

    healthbar.set(1);
    healthbar.animate(poscan);
    healthbar2.set(1);
    healthbar2.animate(poscan);
  }

  if (poszirh != lastzirh) {
    if (poszirh >= 1.0) {
      poszirh = 1.0;
    }

    var armorbar = new ProgressBar.Path("#armor-bar2", {
      easing: "easeInOut",
      duration: 0,
    });
    var armorbar2 = new ProgressBar.Path("#armor-bar88", {
      easing: "easeInOut",
      duration: 0,
    });

    armorbar.set(1);
    armorbar.animate(poszirh);
    armorbar2.set(1);
    armorbar2.animate(poszirh);
  }


  if (poshunger != lastyemek) {
    if (poshunger >= 1.0) {
      poshunger = 1.0;
    }

    var hungerbar = new ProgressBar.Path("#hunger-bar2", {
      easing: "easeInOut",
      duration: 0,
    });
    var hungerbar2 = new ProgressBar.Path("#hunger-bar66", {
      easing: "easeInOut",
      duration: 0,
    });

    hungerbar.set(1);
    hungerbar.animate(poshunger);
    hungerbar2.set(1);
    hungerbar2.animate(poshunger);
  }

  if (possu != lastsu) {
    if (possu >= 1.0) {
      possu = 1.0;
    }
    var thirstybar = new ProgressBar.Path("#thirsty-bar2", {
      easing: "easeInOut",
      duration: 0,
    });
    var thirstybar2 = new ProgressBar.Path("#thirsty-bar99", {
      easing: "easeInOut",
      duration: 0,
    });
    thirstybar.set(1);
    thirstybar.animate(possu);
    thirstybar2.set(1);
    thirstybar2.animate(possu);
  }

  if (posbenzin != lastbenzin) {
    if (posbenzin <= 0.0) {
      posbenzin = 0.0;
    }

    document.querySelector(
      ".fuelani"
    ).style.strokeDasharray = `${posbenzin}, 400`;
  }
}, 1000);





let playerhud = true
setInterval(function () {

  if (playerhud == true) {

    $('.playerhudbank').css('display', 'block');
    $('.playerhudcash').css('display', 'none');

    $('.playerhudbank').text('$ ' + lastbank);


    $('.playerbankimg').css('display', 'block')
    $('.playercashimg').css('display', 'none')
  }


}, 1000)
setInterval(function () {

  playerhud = false


}, 10000)


setInterval(function () {

  if (playerhud == false) {
    $('.playerhudbank').css('display', 'none');
    $('.playerhudcash').css('display', 'block');

    $('.playerhudcash').text('$ ' + lastmoney);
    $(".plycash").attr("src", "./img/moneycash.png")
    $('.playerbankimg').css('display', 'none')
    $('.playercashimg').css('display', 'block')

  }

}, 1000)
setInterval(function () {

  playerhud = true


}, 20000)


