const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const products = [
  ['deep-fate','個人深度命盤解析','personal-deep-fate','從性格、感情、事業、財運、人際與人生方向整理完整個人解析。',299],
  ['love-deep','感情深度解析','love-deep-fate','整理感情中的期待、需求、互動模式與關係盲點。',399],
  ['pair-deep','雙人關係深度解析','pair-deep-fate','比較兩人的性格、情感需求、溝通、衝突與長期相處課題。',599],
  ['yearly-fate','年度人生趨勢解析','yearly-fate','整理年度整體運勢、感情、工作、財運、人際與行動節奏。',499],
  ['direction-deep','人生方向探索','life-direction','從核心性格、能力、工作環境與人生階段整理方向地圖。',699],
];
async function main(){
  for(const [id,name,slug,description,price] of products){
    await prisma.product.upsert({where:{id},update:{name,slug,description,price,currency:'TWD',status:'active'},create:{id,name,slug,description,price,currency:'TWD',status:'active'}});
  }
  console.log(`Seeded ${products.length} products.`);
}
main().catch(e=>{console.error(e);process.exitCode=1}).finally(()=>prisma.$disconnect());
