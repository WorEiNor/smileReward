db = db.getSiblingDB('mydb');

db.rewards.insertMany([
  {
    id: 1,
    name: "Adidas Ultraboost Core Black",
    image_url: "https://picsum.photos/id/10/400/400",
    reward_points: 300,
    reward_desc: "รองเท้าวิ่งยอดนิยม สวมใส่สบายสำหรับการออกกำลังกาย"
  },
  {
    id: 2,
    name: "Nike Air Max 270",
    image_url: "https://picsum.photos/id/20/400/400",
    reward_points: 280,
    reward_desc: "ดีไซน์ล้ำสมัย พร้อมเทคโนโลยีรองรับแรงกระแทก"
  },
  {
    id: 3,
    name: "Apple AirPods Pro",
    image_url: "https://picsum.photos/id/30/400/400",
    reward_points: 4500,
    reward_desc: "หูฟังไร้สายตัดเสียงรบกวน พร้อมเคสชาร์จ"
  },
  {
    id: 4,
    name: "Starbucks Gift Card - ฿200",
    image_url: "https://picsum.photos/id/40/400/400",
    reward_points: 150,
    reward_desc: "บัตรของขวัญ Starbucks มูลค่า 200 บาท คือไอเท็มสุดพิเศษที่ให้คุณหรือคนที่คุณรักได้สัมผัสกับประสบการณ์แห่งความสุขในทุกแก้ว ไม่ว่าจะเป็นคาเฟลาเต้ร้อน ๆ ในเช้าวันจันทร์ ชาเย็นชานมเฟรปปูชิโนเย็นสดชื่นในช่วงบ่าย หรือขนมอบอุ่นใหม่กลิ่นหอมในยามพักผ่อน บัตรนี้สามารถใช้ได้ที่ Starbucks ทุกสาขาทั่วประเทศไทย โดยไม่มีวันหมดอายุและไม่จำกัดประเภทของสินค้าที่สามารถใช้ได้ ไม่ว่าจะคุณจะนั่งทำงาน อัปเดตประชุม นัดเพื่อน หรือพักผ่อนสบาย ๆ ในบรรยากาศอันแสนอบอุ่นของร้าน Starbucks บัตรนี้คือมอบใจที่ถูกใจใส่ใจได้ด้วยหลงรัก นอกจากนี้ยังสามารถใช้ร่วมกับแอป Starbucks Rewards เพื่อสะสมดาว แลกรับเครื่องดื่มฟรี และเข้าร่วมโปรโมชันพิเศษต่าง ๆ ได้อีกด้วย บัตรนี้เหมาะสำหรับมอบเป็นของขวัญในทุกเทศกาล เช่น วันเกิด วันครบรอบ วันแม่ หรือแม้แต่การให้กำลังใจตัวเองในวันที่เหนื่อยล้า ด้วยมูลค่า 200 บาทที่แฝงไว้ด้วยคุณค่าแห่งรอยยิ้มและความประทับใจในการใช้งาน มอบความรู้สึกดี ๆ ให้กับวันของคุณเต็มความหมายมากยิ่งขึ้นด้วย Starbucks Gift Card ใบนี้"
  },
  {
    id: 5,
    name: "Xiaomi Mi Smart Band 7",
    image_url: "https://picsum.photos/id/50/400/400",
    reward_points: 12350,
    reward_desc: "สมาร์ทแบนด์ติดตามเวลา ออกกำลัง และวัดชีพจร"
  },
  {
    id: 6,
    name: "Amazon Echo Dot (4th Gen)",
    image_url: "https://picsum.photos/id/60/400/400",
    reward_points: 10000,
    reward_desc: "ลำโพงอัจฉริยะพร้อม Alexa ผู้ช่วยส่วนตัวสั่งงานด้วยเสียง"
  }
]);

db.users.insertMany([
  { firstname: "smile", lastname: "challenge", email: "smile@smilefokus.com", password:"$2b$10$93lSSSjJbztTdz62EIQwdudKfFYUf0cIYpXOcZ8WzoUbcshOkWlve", points: 10000 },
  { firstname: "somchai", lastname: "lnwza", email: "somchai@lnwza.com", password:"$2b$10$VxYD6UAuri5n2oyg7LSfBeAdlRBcyJk2YGJwcRcTNCC8/NJVoBIk.", points: 5000},
]);

db.createCollection('wishlists');
db.createCollection('claimedrewards');