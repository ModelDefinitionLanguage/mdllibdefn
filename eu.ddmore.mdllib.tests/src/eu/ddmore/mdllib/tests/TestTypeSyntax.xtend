package eu.ddmore.mdllib.tests

import com.google.inject.Inject
import eu.ddmore.mdllib.MdlLibInjectorProvider
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.scoping.MdlLibLib
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(MdlLibInjectorProvider)
class TestTypeSyntax {
	
	@Inject extension MdlLibLib
	
	@Inject extension ParseHelper<Library>
	@Inject	extension ValidationTestHelper

	@Test 
	def void testTypeDeclnSyntax() {
		val result = '''
_type Deriv _deriv;

_type divUse _enum (cov, amt, dv, dvid, cmt, mdv, idv, id, rate, ignore, varLevel, catCov, ss, ii, addl);
_type ddvUse _enum (doseTime);
		'''.loadLibAndParse

		result.assertNoErrors
	}

	def private loadLibAndParse(CharSequence p) {
		p.parse(loadLibrary)
	}
	
	def private loadLibrary() {
		loadLib => [
			resources.forEach [
				contents.get(0).assertNoErrors
			]
		]
	}
}