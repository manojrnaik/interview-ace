@Post('verify')
async verifyPurchase(@Req() req, @Body() body) {
  // Verify receipt with Google / Apple
  // Save subscription in DB
  return { success: true };
}
