# Troubleshooting and FAQ

<cite>
**Referenced Files in This Document**
- [README.MD](file://README.MD)
- [abc=28.py](file://abc=28.py)
- [testforgg01.py](file://testforgg01.py)
- [爬取天气.py](file://爬取天气.py)
</cite>

## Table of Contents
1. [Introduction](#introduction)
2. [Environment Setup and Dependencies](#environment-setup-and-dependencies)
3. [Common Issues and Solutions](#common-issues-and-solutions)
4. [Script-Specific Troubleshooting](#script-specific-troubleshooting)
5. [Debugging Strategies](#debugging-strategies)
6. [Performance and Memory Optimization](#performance-and-memory-optimization)
7. [Best Practices](#best-practices)
8. [FAQ](#faq)
9. [Conclusion](#conclusion)

## Introduction
This document provides comprehensive troubleshooting and frequently asked questions for the Python Study project. It covers environment setup, dependency management, common runtime issues, and debugging strategies for the included scripts. The project contains three primary scripts: a mathematical algorithms exercise, a leap year validator, and a web scraping weather information tool.

## Environment Setup and Dependencies
### Python Version Compatibility
- **Required**: Python 3.x
- **Recommended**: Python 3.7+ for optimal compatibility
- **Verification**: Run `python --version` to check your Python version

### Installing Dependencies
The project requires two external libraries:
- `requests`: HTTP client library
- `beautifulsoup4`: HTML/XML parsing library

Installation command:
```bash
pip install requests beautifulsoup4
```

**Section sources**
- [README.MD:30-34](file://README.MD#L30-L34)

## Common Issues and Solutions

### Dependency Errors
**Problem**: ModuleNotFoundError when importing requests or beautifulsoup4
**Solution**: 
1. Verify pip installation: `pip --version`
2. Install missing dependencies: `pip install requests beautifulsoup4`
3. Check virtual environment activation if using venv
4. Upgrade pip if needed: `python -m pip install --upgrade pip`

**Problem**: SSL certificate verification errors during HTTPS requests
**Solution**:
1. Update certificates: `pip install --upgrade certifi`
2. Or temporarily disable SSL verification (not recommended): `requests.get(url, verify=False)`

### Import Failures
**Problem**: ImportError: cannot import name 'BeautifulSoup'
**Solution**:
1. Ensure correct package installation: `pip install beautifulsoup4`
2. Verify import statement: `from bs4 import BeautifulSoup`
3. Check for conflicting package names

**Problem**: UnicodeDecodeError when processing text files
**Solution**:
1. Specify UTF-8 encoding when opening files
2. Use `errors='ignore'` or `errors='replace'` parameters as needed

### Runtime Exceptions
**Problem**: HTTP 404 or 500 errors from weather website
**Solution**:
1. Verify city code format is correct
2. Check if the target website is accessible
3. Add retry logic with exponential backoff
4. Implement proper error handling around HTTP requests

**Section sources**
- [README.MD:26-28](file://README.MD#L26-L28)

## Script-Specific Troubleshooting

### Mathematical Algorithms Script (abc=28.py)
**Issue**: Infinite loop or extremely slow execution
**Root Cause**: Nested loops with large iteration ranges
**Solution**:
1. Add progress indicators or loop counters
2. Optimize algorithm complexity
3. Consider using itertools.combinations for better performance
4. Add early termination conditions

**Issue**: Incorrect palindrome detection
**Problem**: Case sensitivity and whitespace handling
**Solution**:
1. Normalize input: remove spaces and convert to lowercase
2. Use string slicing for palindrome comparison
3. Test with various input formats

**Issue**: Memory usage spikes during computation
**Solution**:
1. Use generators instead of lists for large datasets
2. Clear unused variables with `del`
3. Process data incrementally rather than storing all results

### Leap Year Validator (testforgg01.py)
**Issue**: Incorrect leap year calculations
**Problem**: Logic errors in year divisibility checks
**Solution**:
1. Verify the leap year formula implementation
2. Test edge cases: years divisible by 100 and 400
3. Add input validation for non-integer values

**Issue**: Function not returning expected boolean values
**Solution**:
1. Ensure explicit return statements
2. Remove redundant `else` clauses
3. Simplify conditional logic

### Weather Scraper (爬取天气.py)
**Issue**: Network timeouts or connection errors
**Solution**:
1. Add timeout parameters to requests
2. Implement retry mechanisms
3. Check firewall and proxy settings
4. Verify internet connectivity

**Issue**: HTML parsing fails due to website structure changes
**Solution**:
1. Update CSS selectors and class names
2. Add fallback parsing strategies
3. Implement robust error handling for missing elements
4. Use more flexible parsing methods

**Issue**: Encoding problems with Chinese characters
**Solution**:
1. Explicitly set response encoding to UTF-8
2. Handle encoding errors gracefully
3. Use proper character encoding in print statements

**Section sources**
- [abc=28.py:1-33](file://abc=28.py#L1-L33)
- [testforgg01.py:1-21](file://testforgg01.py#L1-L21)
- [爬取天气.py:1-36](file://爬取天气.py#L1-L36)

## Debugging Strategies

### Mathematical Algorithms Debugging
**Strategy 1**: Add logging and intermediate results
```python
import logging
logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger(__name__)
```

**Strategy 2**: Use assertions for boundary conditions
```python
assert 1 <= a <= 26, f"Invalid value: {a}"
```

**Strategy 3**: Profile execution time and memory usage
```python
import time
import tracemalloc

start_time = time.time()
tracemalloc.start()

# Your code here

current, peak = tracemalloc.get_traced_memory()
print(f"Current memory usage: {current / 1024 / 1024:.2f} MB")
print(f"Peak memory usage: {peak / 1024 / 1024:.2f} MB")
print(f"Execution time: {time.time() - start_time:.2f} seconds")
```

### Conditional Logic Validation
**Approach**: Create comprehensive test suites
1. Test positive cases: `is_leap_year(2024)` should return `True`
2. Test negative cases: `is_leap_year(1900)` should return `False`
3. Test edge cases: `is_leap_year(2000)`, `is_leap_year(1600)`
4. Test invalid inputs: non-numeric values, None, empty strings

**Debugging Tips**:
1. Print variable states at each condition
2. Use step-through debugging in IDE
3. Break complex conditions into smaller functions

### Web Scraping Network Errors
**Network Debugging Checklist**:
1. Verify URL construction and city codes
2. Check HTTP status codes and error messages
3. Test with curl or browser developer tools
4. Monitor network latency and timeouts

**Error Handling Pattern**:
```python
try:
    response = requests.get(url, timeout=10)
    response.raise_for_status()
except requests.exceptions.Timeout:
    # Handle timeout
except requests.exceptions.ConnectionError:
    # Handle connection issues
except requests.exceptions.RequestException as e:
    # Handle other request errors
```

### Enterprise Integration Connectivity
**Connectivity Testing**:
1. Test proxy configurations if behind corporate firewall
2. Verify SSL/TLS certificate validation
3. Check rate limiting and API quotas
4. Implement circuit breaker patterns for reliability

**Section sources**
- [testforgg01.py:14-20](file://testforgg01.py#L14-L20)

## Performance and Memory Optimization

### Mathematical Algorithms Optimization
**Current Algorithm Analysis**:
- Time Complexity: O(n³) where n = 27
- Space Complexity: O(1) constant
- Potential Bottlenecks: Triple nested loops

**Optimization Strategies**:
1. **Mathematical Approach**: Instead of brute force, use combinatorial mathematics
2. **Early Termination**: Stop loops when conditions are impossible to meet
3. **Caching**: Store previously computed results
4. **Parallel Processing**: Use multiprocessing for independent calculations

**Memory Management**:
- Use generators for large sequences
- Delete large objects when no longer needed
- Monitor memory usage with `tracemalloc`

### Leap Year Calculation
**Optimization**: Current implementation is already optimal for single calculations
**Enhancement**: Cache results for repeated queries
**Alternative Implementation**: Use bitwise operations for divisibility checks

### Web Scraping Performance
**Network Optimization**:
1. **Connection Pooling**: Reuse HTTP connections
2. **Response Caching**: Cache successful responses
3. **Asynchronous Requests**: Use aiohttp for concurrent requests
4. **Content Compression**: Enable gzip compression

**Parsing Optimization**:
1. Use lxml parser for better performance
2. Limit DOM traversal depth
3. Cache parsed elements when reused

**Section sources**
- [abc=28.py:7-24](file://abc=28.py#L7-L24)

## Best Practices

### Code Quality Standards
1. **Documentation**: Include docstrings for all functions
2. **Type Hints**: Add type annotations for better IDE support
3. **Error Handling**: Implement comprehensive exception handling
4. **Logging**: Use structured logging instead of print statements

### Security Considerations
1. **Input Validation**: Always validate and sanitize user inputs
2. **URL Validation**: Verify URLs before making requests
3. **Rate Limiting**: Implement delays between requests
4. **Data Sanitization**: Clean scraped data before processing

### Testing Strategies
1. **Unit Tests**: Test individual functions in isolation
2. **Integration Tests**: Test complete workflows
3. **Edge Cases**: Test boundary conditions and error scenarios
4. **Performance Tests**: Measure execution time and memory usage

### Maintainability
1. **Modular Design**: Break large functions into smaller, focused functions
2. **Configuration Management**: Externalize constants and settings
3. **Code Reviews**: Regular peer review of changes
4. **Documentation Updates**: Keep README and inline comments current

## FAQ

### Environment Setup Issues
**Q: How do I check if my Python installation is compatible?**
A: Run `python --version` and ensure it shows Python 3.x. For best compatibility, use Python 3.7+.

**Q: Why am I getting permission errors when installing packages?**
A: Try using `pip install --user` or run your terminal as administrator. Check if you're in a virtual environment.

**Q: How do I create a virtual environment for this project?**
A: 
```bash
python -m venv pythonstudy_env
pythonstudy_env\Scripts\activate  # Windows
# or
source pythonstudy_env/bin/activate  # Linux/Mac
pip install requests beautifulsoup4
```

### Script Execution Problems
**Q: My mathematical script runs forever - what's wrong?**
A: The triple nested loops iterate 27³ times. Add progress indicators or optimize the algorithm. Check loop bounds and termination conditions.

**Q: The leap year function returns incorrect results**
A: Verify the leap year formula implementation. Test with known leap years like 2024 and non-leap years like 1900.

**Q: Weather scraper shows "未找到天气信息" (Weather information not found)**
A: The website structure may have changed. Update the CSS selectors and class names. Check if the city code is valid.

### Network and Connectivity Issues
**Q: Getting SSL certificate errors**
A: Update your certificates with `pip install --upgrade certifi`. If using corporate proxy, configure proxy settings.

**Q: HTTP 404 errors from weather website**
A: Verify the city code format. The website may have changed its URL structure. Check if the site is currently accessible.

**Q: How do I handle rate limiting?**
A: Add delays between requests using `time.sleep()`. Implement exponential backoff for retries. Respect robots.txt guidelines.

### Performance and Memory Issues
**Q: Scripts are using too much memory**
A: Use generators instead of lists for large datasets. Clear large objects with `del`. Monitor memory usage with profiling tools.

**Q: How can I debug infinite loops?**
A: Add print statements with loop counters. Use `pdb.set_trace()` for interactive debugging. Set maximum iteration limits.

**Section sources**
- [README.MD:36-51](file://README.MD#L36-L51)

## Conclusion
This troubleshooting guide addresses the most common issues encountered when running the Python Study project scripts. By following the environment setup instructions, implementing proper error handling, and applying the debugging strategies outlined above, you should be able to resolve most issues efficiently. Remember to test thoroughly, especially edge cases, and consider the performance implications of your chosen approaches. For the web scraping component, always respect website terms of service and implement appropriate delays to avoid overloading servers.