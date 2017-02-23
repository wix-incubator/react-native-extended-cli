describe('sanity e2e', () => {

  it('should see hello world', () => {
    expect(element(by.label('Welcome to React Native!'))).toBeVisible();
  });

});
