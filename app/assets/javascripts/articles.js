function toggleArticles() {
  const articles = document.querySelectorAll(".article-item.hidden");
  const articleContainer = document.getElementById("article-container");
  for (const article of articles) {
    article.classList.remove("hidden");
  }
  document.getElementById("view-all-button").style.display = "none";

  if (articleContainer) {
    articleContainer.classList.remove("overflow-y-clip");
    // normally i would calculate that height for desired effect
    // look at it as part of mockup
  }
}
