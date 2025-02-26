function toggleArticles() {
  const articles = document.querySelectorAll(".article-item.hidden");
  const articleContainer = document.getElementById("article-container");
  for (const article of articles) {
    article.classList.remove("hidden");
  }
  document.getElementById("view-all-button").style.display = "none";

  if (articleContainer) {
    articleContainer.classList.remove("h-[450px]");
    articleContainer.classList.add("h-[630px]");
    // normally i would calculate that height for desired effect
    // look at it as part of mockup
  }
}
