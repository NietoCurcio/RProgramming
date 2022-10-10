// go to spot on the map in plain Javascript

const body = document.querySelector('body');

const nav = document.querySelector('.sidebar-menu');

console.log(nav);

const [mapLi, dataLi] = nav.children;

// could also get the aTag directly
const [aTag] = mapLi.children;

body.onclick = (event) => {
  event.preventDefault();

  const target = event.target;

  if (target.tagName !== 'A') return;

  const zipcode = target.getAttribute('data-zip');

  if (!zipcode) return;

  const lat = target.getAttribute('data-lat');
  const lng = target.getAttribute('data-long');

  aTag.click();

  Shiny.onInputChange('gotozipcode', {
    lat: Number(lat),
    lng: Number(lng),
    zip: zipcode,
    nonce: Math.random(),
  });
};
