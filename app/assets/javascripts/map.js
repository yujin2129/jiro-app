function initMap() {
  const geocoder = new google.maps.Geocoder();
  const addressElement = document.getElementById("shop-address");
  const mapElement = document.getElementById("map");

  if (!addressElement || !mapElement) {
    return;
  }

  const address = addressElement.innerText;

  geocoder.geocode({ address: address }, function(results, status) {
    if (status === "OK") {
      const map = new google.maps.Map(mapElement, {
        zoom: 15,
        center: results[0].geometry.location,
      });

      new google.maps.Marker({
        map: map,
        position: results[0].geometry.location,
      });
    } else {
      alert("地図の読み込みに失敗しました: " + status);
    }
  });
}

document.addEventListener("turbo:load", initMap);
