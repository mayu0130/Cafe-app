document.addEventListener("DOMContentLoaded", function() {
  const searchInput = document.getElementById("search-input");
  const resultsList = document.getElementById("autocomplete-results");

  searchInput.addEventListener("input", function() {
    const query = searchInput.value;

    // 入力が2文字以上の場合のみ検索
    if (query.length > 1) {
      fetch(`/posts/autocomplete?query=${query}`)
        .then(response => response.json())
        .then(data => {
          console.log(data); // 取得したデータをログで確認
          resultsList.innerHTML = ""; // 検索結果をリセット

          if (data.length > 0) {
            resultsList.classList.remove("hidden"); // 結果を表示
            data.forEach(cafeName => {
              const listItem = document.createElement("li");
              listItem.classList.add("p-2", "cursor-pointer");
              listItem.textContent = cafeName;
              listItem.addEventListener("click", function() {
                searchInput.value = cafeName;
                resultsList.classList.add("hidden"); // 結果を非表示にする
              });
              resultsList.appendChild(listItem);
            });
          } else {
            resultsList.classList.add("hidden"); // 結果がない場合非表示
          }
        })
        .catch(error => {
          console.error("Error fetching autocomplete data:", error);
          resultsList.classList.add("hidden"); // エラー時に非表示
        });
    } else {
      resultsList.classList.add("hidden"); // 入力が少ない場合は非表示
    }
  });

  document.addEventListener("click", function(event) {
    if (!resultsList.contains(event.target) && event.target !== searchInput) {
      resultsList.classList.add("hidden"); // 他の場所をクリックした場合に非表示
    }
  });
});
