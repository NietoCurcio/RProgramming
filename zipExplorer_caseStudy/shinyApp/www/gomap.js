// go to spot on the map in plain Javascript

const body = document.querySelector('body');

const nav = document.getElementById('nav');

const [mapLi, dataLi] = nav.children;
const [aTag] = mapLi.children;

console.log(aTag);

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
