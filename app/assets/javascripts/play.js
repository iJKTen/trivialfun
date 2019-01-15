//= require jquery.min.js
window.onload = function() {
  let url = window.location.href;
  const sections = document.getElementsByTagName("section");
  let nextSectionToScrollIndex = 0;
  let key = [];

  function keyPressed(e){
    if(e.keyCode == 39 || e.keyCode == 32){
      var check_score_url = url.replace("play", "check_score");
      check_score_url = check_score_url.replace("tiebreaker", "check_score");
      $(sections[nextSectionToScrollIndex]).next(".progress-bar").hide();

      if(nextSectionToScrollIndex == sections.length - 1)
        window.location.replace(check_score_url);
      nextSectionToScrollIndex++;
    }
    else if(e.keyCode == 37) {
      if(nextSectionToScrollIndex == 0)
        return;
      nextSectionToScrollIndex--;
    }
    else if (e.keyCode >= 48 && e.keyCode <= 57) {
      key.push(e.key);
      if(key.length == 2) {
        nextSectionToScrollIndex = getSlideIndexToShowWithKey(key[0] + key[1]);
      }
    }

    if (nextSectionToScrollIndex > 0) {
      let $sectionToScroll = $(sections[nextSectionToScrollIndex]);
      let $animation_elem = $sectionToScroll.next(".progress-bar");
      $animation_elem.hide();

      $("html, body").animate({
        scrollTop: $sectionToScroll.offset().top
      }, 2000, function(){
        key = [];
        nextSectionToScrollIndex = -1;
        let $clone = $animation_elem.clone(true);
        $animation_elem.before($clone);
        $animation_elem.remove();
        $clone.show();
        setTimeout(function() {
          $sectionToScroll.find("p").fadeOut();
        }, fade_question_in_mseconds);
      });
    }
  }

  document.body.onkeyup = keyPressed;
}

function getSlideIndexToShowWithKey(key) {
  let slideToStartWith = 5;
  slideToStartWith += parseInt(key);
  return slideToStartWith;
}
