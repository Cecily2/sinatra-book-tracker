// external js: masonry.pkgd.js, imagesloaded.pkgd.js
var toReadGrid = document.querySelector('.to-read-grid');
var msnry;
imagesLoaded( toReadGrid, function() {
  // init Isotope after all images have loaded
  msnry = new Masonry( toReadGrid, {
    itemSelector: '.grid-item',
    percentPosition: true
  });
});

var readGrid = document.querySelector('.read-grid');
var msnryTwo;
imagesLoaded( readGrid, function() {
  // init Isotope after all images have loaded
  msnryTwo = new Masonry( readGrid, {
    itemSelector: '.grid-item',
    percentPosition: true
  });
});
