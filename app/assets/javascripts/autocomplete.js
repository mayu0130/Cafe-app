document.addEventListener("turbo:load", function() {
  const searchInput = document.getElementById("search-input");
  const resultsList = document.getElementById("autocomplete-results");

  function fetchResults(query) {
    if (!query.trim()) {
      resultsList.classList.add("hidden");
      return;
    }

    fetch(`/posts/autocomplete?query=${encodeURIComponent(query)}&t=${new Date().getTime()}`)
      .then(response => response.json())
      .then(data => {
        resultsList.innerHTML = "";

        if (data.length > 0) {
          resultsList.classList.remove("hidden");
          data.forEach(cafeName => {
            const listItem = document.createElement("li");
            listItem.classList.add("p-2", "cursor-pointer");
            listItem.textContent = cafeName;
            listItem.addEventListener("click", function() {あ
              searchInput.value = cafeName;
              resultsList.classList.add("hidden");
            });
            resultsList.appendChild(listItem);
          });
        } else {
          resultsList.classList.add("hidden");
        }
      })
      .catch(error => {
        console.error("Error fetching autocomplete data:", error);
        resultsList.classList.add("hidden");
      });
  }

  function setupEventListeners() {
    searchInput.addEventListener("input", function() {
      fetchResults(searchInput.value);
    });

    searchInput.addEventListener("focus", function() {
      fetchResults(searchInput.value || "");
    });

    searchInput.addEventListener("change", function() {
      fetchResults(searchInput.value);
    });

    document.addEventListener("click", function(event) {
      if (!resultsList.contains(event.target) && event.target !== searchInput) {
        resultsList.classList.add("hidden");
      }
    });
  }

  setupEventListeners();

  if (searchInput.value.length > 0) {
    fetchResults(searchInput.value);
  }
});
