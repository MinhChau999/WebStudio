const crypto = require('crypto');

// --- CẤU HÌNH ---
// Thay đổi secret này GIỐNG HỆT với PGRST_JWT_SECRET trong docker-compose.yaml
const SECRET = "myverysecuresecretthatisatleast32characterslong"; 

// --- Đừng sửa phần dưới này trừ khi bạn biết mình đang làm gì ---
function sign(payload, secret) {
  const header = { alg: 'HS256', typ: 'JWT' };
  const encodedHeader = Buffer.from(JSON.stringify(header)).toString('base64url');
  const encodedPayload = Buffer.from(JSON.stringify(payload)).toString('base64url');
  const signature = crypto.createHmac('sha256', secret)
    .update(encodedHeader + '.' + encodedPayload)
    .digest('base64url');
  return `${encodedHeader}.${encodedPayload}.${signature}`;
}

const payload = {
  iss: "webstudio",
  role: "user", // Role mặc định
  iat: Math.floor(Date.now() / 1000),
  exp: Math.floor(Date.now() / 1000) + 100 * 365 * 24 * 60 * 60 // Hết hạn sau 100 năm
};

console.log("\nToken mới của bạn là:\n");
console.log(sign(payload, SECRET));
console.log("\nCopy token trên và dán vào POSTGREST_API_KEY trong file .env\n");
