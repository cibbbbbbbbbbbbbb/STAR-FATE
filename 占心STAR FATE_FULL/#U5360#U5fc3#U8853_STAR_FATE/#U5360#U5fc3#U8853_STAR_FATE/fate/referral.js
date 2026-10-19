(function(){
  const p=location.pathname.split('/').filter(Boolean).pop();
  if(p&&p!=='index.html')sessionStorage.setItem('starFateReferralCode',p);
})();
