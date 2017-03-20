describe('sanity e2e', () => {

  it('should see hello world', async () => {
    await expect(element(by.label('Welcome to React Native!'))).toBeVisible();
  });

});
