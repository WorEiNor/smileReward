const express = require('express');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

const app = express();
app.use(express.json());

mongoose.connect('mongodb://mongo:27017/smiledb', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});



// JWT Secret (use environment variable in production)
const JWT_SECRET = process.env.JWT_SECRET || 'smileReward';

// User Schema
const userSchema = new mongoose.Schema({
    firstname: String,
    lastname: String,
    email: String,
    password: String,
    points: Number
  });

  const User = mongoose.model('User', userSchema, 'users');



// Reward Schema
const rewardSchema = new mongoose.Schema({
  name: String,
  image_url: String,
  reward_points: Number,
  reward_desc: String,
});

const Reward = mongoose.model('Reward', rewardSchema);
// Middleware to verify JWT token
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1]; // Bearer TOKEN

  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'Access token required'
    });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        error: 'Invalid or expired token'
      });
    }
    req.user = user;
    next();
  });
};

// Auth Routes


// POST /login - Login user
app.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

console.log('Login email:', email);
        console.log('Login password:', password);

const users = await User.find();
console.log(users);
    // Find user by email
    const user = await User.findOne({email: email.trim().toLowerCase()});
    if (!user) {
    console.log('help');
      return res.status(400).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

        console.log('Stored user:', user);
        console.log('Stored hashed password:', user.password);

        const isMatchz = await bcrypt.compare(password, user.password);
        console.log('Password match:', isMatchz);

    // Check password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        success: false,
        error: 'Invalid credentials'
      });
    }

    // Generate token
    const token = jwt.sign(
      { user_id: user._id, email: user.email, firstname: user.firstname, lastname: user.lastname },
      JWT_SECRET,
      { expiresIn: '24h' }
    );
console.log('done')
    res.json({
      success: true,
      data: {
        token,
        user: {
          id: user._id,
          firstname: user.firstname,
          lastname: user.lastname,
          email: user.email,
          points: user.points
        }
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Simple fetch functions
async function getAllRewards() {
  const rewards = await Reward.find({});
    return rewards.map(r => ({
      id: r._id.toString(),  // or r.id if you want your numeric id
      name: r.name,
      image_url: r.image_url,
      reward_points: r.reward_points,
      reward_desc: r.reward_desc
    }));
}

async function getRewardById(id) {
  return await Reward.findById(id); // ✅ NOT "rewards"
}

// Protected Reward Routes (require authentication)

// GET /rewards - Get all rewards (protected)
app.get('/rewards', authenticateToken, async (req, res) => {
  try {
    const rewards = await getAllRewards();
    res.json({
      success: true,
      data: rewards
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET /rewards/:id - Get reward by ID (protected)
app.get('/rewards/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    // ✅ Check if id is a valid ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({
        success: false,
        error: 'Invalid reward ID format'
      });
    }

    const reward = await getRewardById(id);

    if (!reward) {
      return res.status(404).json({
        success: false,
        error: 'Reward not found'
      });
    }

    res.json({
      success: true,
      data: reward
    });
  } catch (error) {
    console.error('Reward fetch error:', error); // helpful for debugging
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET /profile - Get user profile (protected)
app.get('/profile', authenticateToken, async (req, res) => {
  try {
    const user = await User.findById(req.user.user_id).select('-password');
    res.json({
      success: true,
      data: user
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// Wishlist Schema
const Wishlist = mongoose.model('Wishlist', {
    user_id: String,
    reward_id: String,
    added_at: {type: Date, default: Date.now},
});

// ===== WISHLIST ROUTES =====

// POST /wishlist - Add reward to wishlist
app.post('/wishlist', authenticateToken, async (req, res) => {
  try {
    const { reward_id } = req.body;
    const user_id = req.user.user_id;

    // Check if reward exists
    const reward = await Reward.findById(reward_id);
    if (!reward) {
      return res.status(404).json({
        success: false,
        error: 'Reward not found'
      });
    }

    // Check if already in wishlist
    const existingWishlist = await Wishlist.findOne({
      user_id: user_id,
      reward_id: reward_id
    });

    if (existingWishlist) {
      return res.status(400).json({
        success: false,
        error: 'Reward already in wishlist'
      });
    }

    // Add to wishlist
    const wishlistItem = new Wishlist({
      user_id: user_id,
      reward_id: reward_id
    });

    await wishlistItem.save();

    res.status(201).json({
      success: true,
      data: {
        id: wishlistItem._id,
        reward_id: wishlistItem.reward_id,
        added_at: wishlistItem.added_at
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// GET /wishlist - Get user's wishlist
app.get('/wishlist', authenticateToken, async (req, res) => {
  try {
    const user_id = req.user.user_id;

    const wishlistItems = await Wishlist.find({ user_id: user_id })
      .populate('reward_id')
      .sort({ added_at: -1 });

    res.json({
      success: true,
      data: wishlistItems
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

// DELETE /wishlist/:reward_id - Remove reward from wishlist
app.delete('/wishlist/:reward_id', authenticateToken, async (req, res) => {
  try {
    const { reward_id } = req.params;
    const user_id = req.user.user_id;

    const result = await Wishlist.findOneAndDelete({
      user_id: user_id,
      reward_id: reward_id
    });

    if (!result) {
      return res.status(404).json({
        success: false,
        error: 'Reward not found in wishlist'
      });
    }

    res.json({
      success: true,
      message: 'Reward removed from wishlist'
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      error: error.message
    });
  }
});

async function init() {
try {
    const usersExist = await User.countDocuments();
    if (usersExist == 0) {
      await User.insertMany([
            {
              firstname: "smile",
              lastname: "challenge",
              email: "smile@smilefokus.com",
              password: "$2b$10$93lSSSjJbztTdz62EIQwdudKfFYUf0cIYpXOcZ8WzoUbcshOkWlve",
              points: 10000
            },
            {
              firstname: "somchai",
              lastname: "lnwza",
              email: "somchai@lnwza.com",
              password: "$2b$10$VxYD6UAuri5n2oyg7LSfBeAdlRBcyJk2YGJwcRcTNCC8/NJVoBIk.",
              points: 5000
            }
          ]);
    }
    const rewardsExist = await Reward.countDocuments();

if (rewardsExist == 0) {

    await Reward.insertMany([
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
      // Add more rewards if needed...
    ]);
    }

    console.log("Seeding complete.");
  } catch (err) {
    console.error("Error seeding DB:", err);
  }
  }

  init();


app.listen(3000, () => console.log('Server running on port 3000'));