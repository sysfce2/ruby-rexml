require "test/unit"
require "rexml/document"

module REXMLTests
  class TestParseComment < Test::Unit::TestCase
    def parse(xml)
      REXML::Document.new(xml)
    end

    class TestInvalid < self
      def test_toplevel_unclosed_comment
        exception = assert_raise(REXML::ParseException) do
          parse("<!--")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Unclosed comment
          Line: 1
          Position: 4
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_toplevel_malformed_comment_inner
        exception = assert_raise(REXML::ParseException) do
          parse("<!-- -- -->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 11
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_toplevel_malformed_comment_end
        exception = assert_raise(REXML::ParseException) do
          parse("<!-- --->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 9
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_doctype_malformed_comment_inner
        exception = assert_raise(REXML::ParseException) do
          parse("<!DOCTYPE foo [<!-- -- -->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 26
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_doctype_malformed_comment_end
        exception = assert_raise(REXML::ParseException) do
          parse("<!DOCTYPE foo [<!-- --->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 24
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_after_doctype_malformed_comment_inner
        exception = assert_raise(REXML::ParseException) do
          parse("<a><!-- -- -->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 14
          Last 80 unconsumed characters:
        DETAIL
      end

      def test_after_doctype_malformed_comment_end
        exception = assert_raise(REXML::ParseException) do
          parse("<a><!-- --->")
        end
        assert_equal(<<~DETAIL, exception.to_s)
          Malformed comment
          Line: 1
          Position: 12
          Last 80 unconsumed characters:
        DETAIL
      end
    end
  end
end
