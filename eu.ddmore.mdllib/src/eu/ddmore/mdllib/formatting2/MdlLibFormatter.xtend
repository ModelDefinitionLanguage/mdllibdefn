/*
 * generated by Xtext
 */
package eu.ddmore.mdllib.formatting2

import com.google.inject.Inject
import eu.ddmore.mdllib.mdllib.AbstractTypeDefinition
import eu.ddmore.mdllib.mdllib.BlockDefinition
import eu.ddmore.mdllib.mdllib.ContainmentDefn
import eu.ddmore.mdllib.mdllib.EnumValue
import eu.ddmore.mdllib.mdllib.FunctionDefnBody
import eu.ddmore.mdllib.mdllib.Library
import eu.ddmore.mdllib.mdllib.ObjectDefinition
import eu.ddmore.mdllib.mdllib.PropertyDefinitionStatement
import eu.ddmore.mdllib.mdllib.TypeDefinition
import eu.ddmore.mdllib.services.MdlLibGrammarAccess
import org.eclipse.xtext.formatting2.AbstractFormatter2
import org.eclipse.xtext.formatting2.IFormattableDocument

class MdlLibFormatter extends AbstractFormatter2 {
	
	@Inject extension MdlLibGrammarAccess

	def dispatch void format(Library library, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (AbstractTypeDefinition abstractTypeDefinition : library.getTypeDefns()) {
			abstractTypeDefinition.format;
		}
		for (PropertyDefinitionStatement propertyDefinitionStatement : library.getPropertyDefns()) {
			propertyDefinitionStatement.format;
		}
		for (ObjectDefinition objectDefinition : library.getObjectDefns()) {
			objectDefinition.format;
		}
		for (BlockDefinition blockDefinition : library.getBlockDefns()) {
			blockDefinition.format;
		}
		for (ContainmentDefn containmentDefn : library.getContainDefns()) {
			containmentDefn.format;
		}
		for (FunctionDefnBody functionDefnBody : library.getFuncDefns()) {
			functionDefnBody.format;
		}
	}

	def dispatch void format(TypeDefinition typeDefinition, extension IFormattableDocument document) {
		// TODO: format HiddenRegions around keywords, attributes, cross references, etc. 
		for (EnumValue enumValue : typeDefinition.getEnumArgs()) {
			enumValue.format;
		}
	}
	
	// TODO: implement for BlockDefinition, ArgumentDefinition, ListTypeDefinition, ListAttributeDefn, ListSignature, SubListTypeDefinition, MappingTypeDefinition, PropertyDefinitionStatement, PropertyDefinition, FunctionDefnBody, FunctionSpec, UnnamedFuncArgs, FuncArgumentDefinition, NamedFuncArgs, SignatureList, TypeSpec
}
